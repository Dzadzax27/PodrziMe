import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/screens/all_takmicars.dart';

class PregledDonacijaScreen extends StatefulWidget {
  const PregledDonacijaScreen({super.key});

  @override
  State<PregledDonacijaScreen> createState() => _PregledDonacijaScreenState();
}

class _PregledDonacijaScreenState extends State<PregledDonacijaScreen> {
  bool _isLoading = true;

  List<Takmicar> _takmicari = [];
  List<Donacija> _donacije = [];

  double _ukupnoSkupljeno = 0;
  double _ukupnoZeljeno = 0;

  final Map<int, double> _skupljenoPoKategoriji = {};
  final Map<int, double> _ciljPoKategoriji = {};

  @override
  void initState() {
    super.initState();
    _ucitajPodatke();
  }

  Future<void> _ucitajPodatke() async {
    final donacijaProvider = context.read<DonacijaProvider>();
    final takmicarProvider = context.read<TakmicarProvider>();

    final filter = {'isKategorijaIncluded': true};

    final donacijeResponse = await donacijaProvider.get();
    final takmicariResponse = await takmicarProvider.get(filter: filter);

    _donacije = donacijeResponse.result ?? [];
    _takmicari = takmicariResponse.result ?? [];

    _izracunajSve();

    setState(() => _isLoading = false);
  }

  void _izracunajSve() {
    _skupljenoPoKategoriji.clear();
    _ciljPoKategoriji.clear();

    final Map<int, int> kandidatKategorija = {};

    for (var t in _takmicari) {
      if (t.kandidatId != null && t.kategorijaId != null) {
        kandidatKategorija[t.kandidatId!] = t.kategorijaId!;
        _ciljPoKategoriji[t.kategorijaId!] =
            (_ciljPoKategoriji[t.kategorijaId!] ?? 0) +
            (t.zeljenaDonacija ?? 0);
      }
    }

    for (var d in _donacije) {
      final kandidatId = d.donorId;
      if (kandidatId == null) continue;

      final kategorijaId = kandidatKategorija[kandidatId];
      if (kategorijaId == null) continue;

      _skupljenoPoKategoriji[kategorijaId] =
          (_skupljenoPoKategoriji[kategorijaId] ?? 0) + (d.iznosDonacije ?? 0);
    }

    _ukupnoSkupljeno = _skupljenoPoKategoriji.values.fold(0, (a, b) => a + b);
    _ukupnoZeljeno = _ciljPoKategoriji.values.fold(0, (a, b) => a + b);
  }

  double _progressZaKategoriju(int kategorijaId) {
    final skupljeno = _skupljenoPoKategoriji[kategorijaId] ?? 0;
    final cilj = _ciljPoKategoriji[kategorijaId] ?? 0;
    if (cilj == 0) return 0;
    return (skupljeno / cilj).clamp(0.0, 1.0);
  }

  Widget _ukupniProgressCard(double progress) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ukupne donacije',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'BAM ${_ukupnoSkupljeno.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Goal\nBAM ${_ukupnoZeljeno.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kategorijaCard({
    required String naziv,
    required int kategorijaId,
    required String imageAsset,
    required String filterNaziv,
    required String citat,
  }) {
    final progress = _progressZaKategoriju(kategorijaId);
    final skupljeno = _skupljenoPoKategoriji[kategorijaId] ?? 0;
    final cilj = _ciljPoKategoriji[kategorijaId] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PregledSvihTakmicara(initialCategory: filterNaziv),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // kompaktna kartica
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                imageAsset,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    naziv,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    citat,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Skupljeno',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'BAM ${skupljeno.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Goal', style: TextStyle(fontSize: 12)),
                          Text(
                            'BAM ${cilj.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ukupniProgress = _ukupnoZeljeno == 0
        ? 0.0
        : (_ukupnoSkupljeno / _ukupnoZeljeno).clamp(0.0, 1.0);

    return MasterScreenWidget(
      title: "Donacije",
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  _ukupniProgressCard(ukupniProgress),
                  const SizedBox(height: 90),

                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // uvijek 3 kolone
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.7, // ⚡ kompaktna visina kartice
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _kategorijaCard(
                        naziv: 'Edukacija',
                        kategorijaId: 2,
                        imageAsset: 'assets/images/education.jpg',
                        filterNaziv: 'Edukacija',
                        citat: 'Edukacija je investicija u budućnost.',
                      ),
                      _kategorijaCard(
                        naziv: 'Sport',
                        kategorijaId: 1,
                        imageAsset: 'assets/images/sport.jpg',
                        filterNaziv: 'Sport',
                        citat: 'Sportisti su naši najveći ambasadori.',
                      ),
                      _kategorijaCard(
                        naziv: 'Umjetnost',
                        kategorijaId: 3,
                        imageAsset: 'assets/images/art.jpg',
                        filterNaziv: 'Umjetnost',
                        citat: 'Umjetnost je srce društva.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
