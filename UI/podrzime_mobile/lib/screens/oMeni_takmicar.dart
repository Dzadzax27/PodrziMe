import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:podrzime_mobile/modals/donacija.dart';
import 'package:podrzime_mobile/modals/donor.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';
import 'package:podrzime_mobile/modals/uloga.dart';

import 'package:podrzime_mobile/providers/donacije_provider.dart';
import 'package:podrzime_mobile/providers/donor_provider.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/providers/uloga_provider.dart';

import 'package:podrzime_mobile/screens/pregled_takmicara.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';

class OMeniTakmicar extends StatefulWidget {
  const OMeniTakmicar({super.key});

  @override
  State<OMeniTakmicar> createState() => _OMeniTakmicarState();
}

class _OMeniTakmicarState extends State<OMeniTakmicar> {
  late TakmicarProfilProvider _takmicarProfilProvider;
  late TakmicarProvider _takmicarProvider;
  late UlogaProvider _ulogaProvider;
  late DonorProvider _donorProvider;
  late DonacijaProvider _donacijaProvider;

  TakmicarProfil? korisnikProfil;
  Donor? donor;

  List<Takmicar>? takmicari;
  List<Takmicar>? pendingTakmicar;
  List<Takmicar>? prihvaceniTakmicar;
  List<Takmicar>? odbijeniTakmicar;

  List<Donacija>? donacije;

  bool sortDescending = true;
  bool sortDescendingDate = true;
  String? activeSort; // 'iznos' | 'datum'

  int? _kategorijaDonorId;
  int? _kategorijaTakmicarId;

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _takmicarProfilProvider = context.read<TakmicarProfilProvider>();
    _takmicarProvider = context.read<TakmicarProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _donorProvider = context.read<DonorProvider>();
    _donacijaProvider = context.read<DonacijaProvider>();

    _loadKategorije();
    loadKorisnika();
    loadZahtjeveTakmicara();
    loadDonor();
  }

  Future<void> loadDonor() async {
    setState(() => isLoading = true);

    final donorList = await _donorProvider.get();
    final lista = donorList
        .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
        .toList();

    donor = lista.isNotEmpty ? lista.first : null;
    isLoading = false;

    if (donor != null) {
      await loadDonacije();
    }
    setState(() {});
  }

  Future<void> loadDonacije() async {
    donacije = await _donacijaProvider.get();
    donacije = donacije?.where((x) => x.donorId == donor!.donorId).toList();
    setState(() {});
  }

  void sortirajDonacije() {
    if (donacije == null) return;
    donacije!.sort(
      (a, b) => sortDescending
          ? (b.iznosDonacije ?? 0).compareTo(a.iznosDonacije ?? 0)
          : (a.iznosDonacije ?? 0).compareTo(b.iznosDonacije ?? 0),
    );
  }

  void sortirajPoDatumu() {
    if (donacije == null) return;
    donacije!.sort(
      (a, b) => sortDescendingDate
          ? (b.datumDonacije ?? DateTime(1900)).compareTo(
              a.datumDonacije ?? DateTime(1900),
            )
          : (a.datumDonacije ?? DateTime(1900)).compareTo(
              b.datumDonacije ?? DateTime(1900),
            ),
    );
  }

  Future<void> loadKorisnika() async {
    setState(() => isLoading = true);

    final list = await _takmicarProfilProvider.get();
    final filtered = list
        .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
        .toList();

    korisnikProfil = filtered.isNotEmpty ? filtered.first : null;

    setState(() => isLoading = false);
  }

  Future<void> _loadKategorije() async {
    final result = await _ulogaProvider.get();
    for (var k in result) {
      if (k.nazivUloge == 'Donor') _kategorijaDonorId = k.ulogaId;
      if (k.nazivUloge == 'Takmicar') _kategorijaTakmicarId = k.ulogaId;
    }
    setState(() {});
  }

  Future<void> loadZahtjeveTakmicara() async {
    final filter = {'isKategorijaIncluded': true};
    takmicari = await _takmicarProvider.get(filter);

    takmicari = takmicari
        ?.where((x) => x.takmicarProfilId == korisnikProfil?.takmicarProfilId)
        .toList();

    pendingTakmicar = takmicari?.where((x) => x.odobren == null).toList();
    prihvaceniTakmicar = takmicari?.where((x) => x.odobren == true).toList();
    odbijeniTakmicar = takmicari?.where((x) => x.odobren == false).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moj profil",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kategorijaTakmicarId == Logiranikorisnik.korisnik?.ulogaId
          ? _buildTakmicarView()
          : _kategorijaDonorId == Logiranikorisnik.korisnik?.ulogaId
          ? _buildDonorView()
          : const Center(child: Text("Profil nije pronađen")),
    );
  }

  Widget _buildTakmicarView() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : korisnikProfil == null
        ? const Center(child: Text("Profil nije pronađen"))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profil korisnika
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24), // ⬅ veći padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ime + Prezime kao naslov
                        Text(
                          "${korisnikProfil!.ime} ${korisnikProfil!.prezime}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _infoRowTakmicar(
                          Icons.person,
                          "Ime",
                          korisnikProfil!.ime ?? "Nije uneseno",
                        ),

                        const SizedBox(height: 12),

                        _infoRowTakmicar(
                          Icons.badge,
                          "Prezime",
                          korisnikProfil!.prezime ?? "Nije uneseno",
                        ),

                        const SizedBox(height: 12),

                        _infoRowTakmicar(
                          Icons.cake,
                          "Datum rođenja",
                          korisnikProfil!.datumRodjenja != null
                              ? DateFormat(
                                  'dd.MM.yyyy',
                                ).format(korisnikProfil!.datumRodjenja!)
                              : "Nije unesen",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Pending takmicari
                const Text(
                  'Zahtjevi na čekanju',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (pendingTakmicar == null || pendingTakmicar!.isEmpty)
                  const Text(
                    "Nema takmicara na čekanju",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: pendingTakmicar!
                        .map((e) => TakmicarCard(e))
                        .toList(),
                  ),

                const SizedBox(height: 16),
                // Prihvaceni takmicari
                const Text(
                  'Prihvaćeni zahtjevi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (prihvaceniTakmicar == null || prihvaceniTakmicar!.isEmpty)
                  const Text(
                    "Nema prihvaćenih takmicara",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: prihvaceniTakmicar!
                        .map((e) => TakmicarCard(e))
                        .toList(),
                  ),

                const SizedBox(height: 16),
                // Odbijeni takmicari
                const Text(
                  'Odbijeni zahtjevi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (odbijeniTakmicar == null || odbijeniTakmicar!.isEmpty)
                  const Text(
                    "Nema odbijenih takmicara",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: odbijeniTakmicar!
                        .map((e) => TakmicarCard(e))
                        .toList(),
                  ),
              ],
            ),
          );
  }

  Widget _infoRowTakmicar(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // ===================== DONOR VIEW =====================

  Widget _buildDonorView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileCard(
            donor!.ime,
            donor!.prezime,
            donor!.zanimanje,
            donor!.datumRodjenja,
          ),
          const SizedBox(height: 20),
          const Text(
            "Donacije",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildFilterChip(
                icon: Icons.attach_money,
                label: "Iznos",
                arrowDown: sortDescending,
                isActive: activeSort == 'iznos',
                onTap: () {
                  setState(() {
                    activeSort = 'iznos';
                    sortDescending = !sortDescending;
                    sortirajDonacije();
                  });
                },
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                icon: Icons.calendar_today,
                label: "Datum",
                arrowDown: sortDescendingDate,
                isActive: activeSort == 'datum',
                onTap: () {
                  setState(() {
                    activeSort = 'datum';
                    sortDescendingDate = !sortDescendingDate;
                    sortirajPoDatumu();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (donacije == null || donacije!.isEmpty)
            const Text("Nema donacija", style: TextStyle(color: Colors.grey))
          else
            Column(
              children: donacije!.map((d) {
                return Card(
                  child: ListTile(
                    title: Text(
                      "BAM ${d.iznosDonacije}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat(
                        'dd.MM.yyyy',
                      ).format(d.datumDonacije ?? DateTime.now()),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // ===================== FILTER CHIP =====================

  Widget _buildFilterChip({
    required IconData icon,
    required bool arrowDown,
    required VoidCallback onTap,
    required String label,
    required bool isActive,
  }) {
    final Color color = arrowDown ? Colors.green : Colors.blue;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? color.withOpacity(0.12) : Colors.white,
          border: Border.all(color: isActive ? color : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? color : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? color : Colors.grey,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: arrowDown ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                color: isActive ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(
    String ime,
    String prezime,
    String? zanimanje,
    DateTime? datum,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24), // ⬅ VEĆI PADDING
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$ime $prezime",
              style: const TextStyle(
                fontSize: 22, // ⬅ VEĆI FONT
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _infoRow("Zanimanje", zanimanje ?? "Nije uneseno"),
            const SizedBox(height: 12),
            _infoRow(
              "Datum rođenja",
              datum != null
                  ? DateFormat('dd.MM.yyyy').format(datum)
                  : "Nije unesen",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class TakmicarCard extends StatelessWidget {
  final Takmicar e;
  const TakmicarCard(this.e, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            e.slika != null && e.slika!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      base64Decode(e.slika!.split(',').last),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.person, size: 80, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${e.ime} ${e.prezime}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.kategorija?.nazivKategorije ?? "",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PregledTakmicara(e),
                        ),
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Pogledaj više",
                            style: TextStyle(
                              color: Color.fromARGB(255, 191, 69, 60),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: Color.fromARGB(255, 191, 69, 60),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
