import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/donacija.dart';
import 'package:podrzime_mobile/modals/donor.dart';
import 'package:podrzime_mobile/modals/kategorija.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';
import 'package:podrzime_mobile/modals/uloga.dart';
import 'package:podrzime_mobile/providers/donacije_provider.dart';
import 'package:podrzime_mobile/providers/donor_provider.dart';
import 'package:podrzime_mobile/providers/kategorija_provider.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/providers/uloga_provider.dart';
import 'package:podrzime_mobile/screens/pregled_takmicara.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OMeniTakmicar extends StatefulWidget {
  const OMeniTakmicar({super.key});

  @override
  State<OMeniTakmicar> createState() => _OMeniTakmicarState();
}

class _OMeniTakmicarState extends State<OMeniTakmicar> {
  late TakmicarProfilProvider _takmicarProfilProvider;
  late TakmicarProvider _takmicarProvider;
  TakmicarProfil? korisnikProfil;
  List<Takmicar>? takmicari;
  List<Takmicar>? pendingTakmicar;
  List<Takmicar>? prihvaceniTakmicar;
  List<Takmicar>? odbijeniTakmicar;
  late UlogaProvider _ulogaProvider;
  List<Uloga>? uloge = [];
  int? _kategorijaDonorId;
  int? _kategorijaTakmicarId;
  late DonorProvider _donorProvider;
  Donor? donor;
  late DonacijaProvider _donacijaProvider;
  List<Donacija>? donacije;
  bool sortDescending = true;
  bool sortDescendingDate = true;

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

  Future<void> loadDonacije() async {
    donacije = await _donacijaProvider.get();

    setState(() {
      donacije = donacije?.where((x) => x.donorId == donor!.donorId).toList();
    });
  }

  Future<void> loadDonor() async {
    setState(() => isLoading = true);

    var donorList = await _donorProvider.get();
    final lista = donorList
        .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
        .toList();

    print('Listaa ${lista}');

    setState(() {
      donor = lista.isNotEmpty ? lista.first : null;
      isLoading = false;
    });

    // Only load donacije after donor is loaded
    if (donor != null) {
      await loadDonacije();
    }
  }

  void sortirajDonacije() {
    setState(() {
      if (donacije != null) {
        donacije!.sort(
          (a, b) => sortDescending
              ? (b.iznosDonacije ?? 0).compareTo(a.iznosDonacije ?? 0)
              : (a.iznosDonacije ?? 0).compareTo(b.iznosDonacije ?? 0),
        );
      }
    });
  }

  void sortirajPoDatumu() {
    setState(() {
      if (donacije != null) {
        donacije!.sort(
          (a, b) => sortDescending
              ? (b.datumDonacije ?? DateTime(1900)).compareTo(
                  a.datumDonacije ?? DateTime(1900),
                )
              : (a.datumDonacije ?? DateTime(1900)).compareTo(
                  b.datumDonacije ?? DateTime(1900),
                ),
        );
      }
    });
  }

  Future<void> loadKorisnika() async {
    setState(() {
      isLoading = true;
    });

    var korisnikProfilList = await _takmicarProfilProvider.get();
    final lista = korisnikProfilList
        .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
        .toList();

    setState(() {
      korisnikProfil = lista.isNotEmpty ? lista.first : null;
      isLoading = false;
    });
  }

  Future<void> _loadKategorije() async {
    final result = await _ulogaProvider.get();
    var _idTakmicar;
    var idDonor;
    for (var k in result) {
      if (k.nazivUloge == 'Donor') {
        idDonor = k.ulogaId;
      } else if (k.nazivUloge == 'Takmicar') {
        _idTakmicar = k.ulogaId;
      }
    }
    setState(
      () => {
        uloge = result,
        _kategorijaDonorId = idDonor,
        _kategorijaTakmicarId = _idTakmicar,
      },
    );
  }

  Future<void> loadZahtjeveTakmicara() async {
    var filter = {'isKategorijaIncluded': true};
    takmicari = await _takmicarProvider.get(filter);

    // filtriraj samo takmicare koji pripadaju korisnikovom profilu
    takmicari = (takmicari ?? [])
        .where((x) => x.takmicarProfilId == korisnikProfil?.takmicarProfilId)
        .toList();

    pendingTakmicar = (takmicari ?? [])
        .where((x) => x.odobren == null)
        .toList();

    prihvaceniTakmicar = (takmicari ?? [])
        .where((x) => x.odobren == true)
        .toList();

    odbijeniTakmicar = (takmicari ?? [])
        .where((x) => x.odobren == false)
        .toList();

    setState(() {}); // trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moj profil",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kategorijaTakmicarId == Logiranikorisnik.korisnik?.ulogaId
          ? _buildTakmicarView() // postojaći kod za takmičara
          : _kategorijaDonorId == Logiranikorisnik.korisnik?.ulogaId
          ? _buildDonorView() // donor layout
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ime: ${korisnikProfil!.ime}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Prezime: ${korisnikProfil!.prezime}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Datum rođenja: ${korisnikProfil!.datumRodjenja != null ? DateFormat('dd.MM.yyyy').format(korisnikProfil!.datumRodjenja!) : 'Nije unesen'}",
                          style: const TextStyle(fontSize: 18),
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

  Widget _buildDonorView() {
    final donorDonacije = (donor != null && donacije != null)
        ? donacije!.where((x) => x.donorId == donor!.donorId).toList()
        : [];

    return donor == null
        ? const Center(child: Text("Donor profil nije pronađen"))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ime: ${donor!.ime}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Prezime: ${donor!.prezime}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Zanimanje: ${donor!.zanimanje ?? 'Nije uneseno'}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Datum rođenja: ${donor!.datumRodjenja != null ? DateFormat('dd.MM.yyyy').format(donor!.datumRodjenja!) : 'Nije unesen'}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Donacije",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    _buildFilterChip(
                      icon: Icons.attach_money,
                      arrowDown: sortDescending,
                      label: "Iznos",
                      onTap: () {
                        sortirajDonacije();
                        setState(() => sortDescending = !sortDescending);
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildFilterChip(
                      icon: Icons.calendar_today,
                      arrowDown: true,
                      label: "Datum",
                      onTap: () {
                        setState(() {
                          sortDescendingDate = !sortDescendingDate;
                          sortirajPoDatumu();
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                donorDonacije.isEmpty
                    ? const Text(
                        "Nema donacija",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Column(
                        children: donorDonacije.map((d) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text("Donacija: ${d.iznosDonacije ?? 0}"),
                              subtitle: Text(
                                "Datum: ${d.datumDonacije != null ? DateFormat('dd.MM.yyyy').format(d.datumDonacije!) : 'Nije unesen'}",
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required bool arrowDown,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Icon(
              arrowDown ? Icons.arrow_downward : Icons.arrow_upward,
              size: 14,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget za prikaz jednog takmicara
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
