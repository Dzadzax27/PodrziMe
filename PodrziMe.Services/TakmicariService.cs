using AutoMapper;
using EasyNetQ;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class TakmicariService : BaseCRUDService<Model.Kandidat, Database.Kandidat, Model.SearchObjects.KandidatiSearchObject, InsertKandidatRequest, UpdateKandidatRequest>, ITakmicariService
    {
        PodrziMeContext _context;
        IMapper _mapper;
        public TakmicariService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
            _context = dbContext;
            _mapper = mapper;
        }

        public override IQueryable<Database.Kandidat> AddFilter(KandidatiSearchObject? search, IQueryable<Database.Kandidat> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.Ime.StartsWith(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Prezime.Contains(search.FTS));
            }

            return base.AddFilter(search, query);
        }


        public override IQueryable<Database.Kandidat> AddInclude(IQueryable<Database.Kandidat> query, KandidatiSearchObject? search = null)
        {
            if (search?.isKategorijaIncluded == true)
            {
                query = query
                    .Include(x => x.Kategorija);
            }
            return base.AddInclude(query, search);
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Model.Kandidat> Recommend(int donorId)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var donationData = _context.Donacijas.ToList();

                    var data = donationData.Select(x => new DonationEntry
                    {
                        DonorID = (uint)x.DonorId,
                        CandidateID = (uint)x.KandidatId,
                        Label = (float)x.IznosDonacije
                    }).ToList();

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    var options = new MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(DonationEntry.DonorID),
                        MatrixRowIndexColumnName = nameof(DonationEntry.CandidateID),
                        LabelColumnName = nameof(DonationEntry.Label),
                        LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                        Alpha = 0.01,
                        Lambda = 0.025,
                        NumberOfIterations = 100,
                        C = 0.00001
                    };

                    model = mlContext.Recommendation()
                                     .Trainers
                                     .MatrixFactorization(options)
                                     .Fit(trainData);
                }
            }

            if (model == null)
                throw new Exception("Model nije učitan! Provjeri path i treniranje.");

            var validCandidateIds = _context.Donacijas
            .Select(x => x.KandidatId)
            .Distinct()
            .ToList();

            var allCandidates = _context.Kandidats
                .Where(x => x.Odobren == true && validCandidateIds.Contains(x.KandidatId))
                .Include(x => x.Kategorija)
                .ToList();


            var predictionEngine =
                mlContext.Model.CreatePredictionEngine<DonationEntry, Copurchase_prediction>(model);

            var predictionScores = new List<(Database.Kandidat kandidat, float score)>();

            foreach (var candidate in allCandidates)
            {
                var prediction = predictionEngine.Predict(new DonationEntry
                {
                    DonorID = (uint)donorId,
                    CandidateID = (uint)candidate.KandidatId
                });

                predictionScores.Add((candidate, prediction.Score));
            }

            var alreadyDonatedIds = _context.Donacijas
                .Where(x => x.KandidatId == donorId)
                .Select(x => x.KandidatId)
                .ToList();

            var lastDonation = _context.Donacijas
                .Where(x => x.DonorId == donorId)
                .OrderByDescending(x => x.DonacijaId)
                .FirstOrDefault();

            int? donorCategoryId = lastDonation?.Kandidat?.KategorijaId;

            var filtered = predictionScores
                .Where(x =>
                    !alreadyDonatedIds.Contains(x.kandidat.KandidatId) &&         
                    (donorCategoryId == null || x.kandidat.KategorijaId == donorCategoryId) 
                )
                .OrderByDescending(x => x.score)
                .Take(3)
                .Select(x => x.kandidat)
                .ToList();

            return _mapper.Map<List<Model.Kandidat>>(filtered);
        }

    }

    public class Copurchase_prediction
        {
            public float Score { get; set; }
        }

        public class DonationEntry
        {
            [KeyType(count: 1000)]
            public uint DonorID { get; set; }

            [KeyType(count: 1000)]
            public uint CandidateID { get; set; }

            public float Label { get; set; }  
        }
}
