import 'package:flutter/material.dart';
import 'package:podrzime_admin/screens/all_takmicars.dart';
import 'package:provider/provider.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';

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
        final cilj = t.zeljenaDonacija ?? 0;
        _ciljPoKategoriji[t.kategorijaId!] =
            (_ciljPoKategoriji[t.kategorijaId!] ?? 0) + cilj;
      }
    }

    for (var d in _donacije) {
      final kandidatId = d.donorId;
      if (kandidatId == null) continue;

      final kategorijaId = kandidatKategorija[kandidatId];
      if (kategorijaId == null) continue;

      final iznos = d.iznosDonacije ?? 0;
      _skupljenoPoKategoriji[kategorijaId] =
          (_skupljenoPoKategoriji[kategorijaId] ?? 0) + iznos;
    }

    _ukupnoSkupljeno = _skupljenoPoKategoriji.values.fold(0.0, (a, b) => a + b);
    _ukupnoZeljeno = _ciljPoKategoriji.values.fold(0.0, (a, b) => a + b);
  }

  double _progressZaKategoriju(int kategorijaId) {
    final skupljeno = _skupljenoPoKategoriji[kategorijaId] ?? 0;
    final cilj = _ciljPoKategoriji[kategorijaId] ?? 0;

    if (cilj == 0) return 0;
    return (skupljeno / cilj).clamp(0.0, 1.0);
  }

  Widget _kategorijaCard({
    required String naziv,
    required int kategorijaId,
    required String imageAsset,
    required IconData icon,
    required String filterNaziv,
  }) {
    final progress = _progressZaKategoriju(kategorijaId);
    final skupljeno = _skupljenoPoKategoriji[kategorijaId] ?? 0;
    final cilj = _ciljPoKategoriji[kategorijaId] ?? 0;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  PregledSvihTakmicara(initialCategory: filterNaziv),
            ),
          );
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          naziv,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 14,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}% ostvareno',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Skupljeno: ${skupljeno.toInt()} / ${cilj.toInt()}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ukupniProgress = _ukupnoZeljeno == 0
        ? 0
        : (_ukupnoSkupljeno / _ukupnoZeljeno).clamp(0.0, 1.0);

    return MasterScreenWidget(
      title: "Pregled donacija",
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text(
                            'Ukupni napredak donacija',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: ukupniProgress.toDouble(),
                              minHeight: 18,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(ukupniProgress * 100).toStringAsFixed(1)}% ukupno '
                            '(${_ukupnoSkupljeno.toInt()} / ${_ukupnoZeljeno.toInt()})',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _kategorijaCard(
                        naziv: 'Sport',
                        kategorijaId: 1,
                        icon: Icons.sports_soccer,
                        imageAsset: 'assets/images/sport.jpg',
                        filterNaziv: 'Sport',
                      ),
                      const SizedBox(width: 16),
                      _kategorijaCard(
                        naziv: 'Edukacija',
                        kategorijaId: 2,
                        icon: Icons.school,
                        imageAsset: 'assets/images/education.jpg',
                        filterNaziv: 'Edukacija',
                      ),
                      const SizedBox(width: 16),
                      _kategorijaCard(
                        naziv: 'Umjetnost',
                        kategorijaId: 3,
                        icon: Icons.brush,
                        imageAsset: 'assets/images/art.jpg',
                        filterNaziv: 'Umjetnost',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
