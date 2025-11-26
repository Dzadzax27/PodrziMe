import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:provider/provider.dart';
import 'package:podrzime_mobile/modals/obavijest.dart';
import 'package:podrzime_mobile/providers/obavijest_provider.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';

class ObavijestiPage extends StatefulWidget {
  const ObavijestiPage({super.key});

  @override
  State<ObavijestiPage> createState() => _ObavijestiPageState();
}

class _ObavijestiPageState extends State<ObavijestiPage> {
  late TakmicarProfilProvider _takmicarProfilProvider;
  late ObavijestProvider _obavijestProvider;
  late TakmicarProvider _takmicarProvider;
  List<Obavijest> obavijesti = [];
  List<Takmicar>? takmicari;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _obavijestProvider = context.read<ObavijestProvider>();
    _takmicarProfilProvider = context.read<TakmicarProfilProvider>();
    _takmicarProvider = context.read<TakmicarProvider>();
    loadObavijesti();
  }

  Future<void> loadObavijesti() async {
    setState(() {
      isLoading = true;
    });

    var korisnikProfilList = await _takmicarProfilProvider.get();
    final lista = korisnikProfilList
        .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
        .toList();

    List<Obavijest> listaKorisnika = [];
    var listaSvih = await _obavijestProvider.get();

    var korisnikProfil = lista.isNotEmpty ? lista.first : null;

    print('Lista obavijesti ${korisnikProfil}');

    takmicari = await _takmicarProvider.get();

    takmicari = (takmicari ?? [])
        .where((x) => x.takmicarProfilId == korisnikProfil?.takmicarProfilId)
        .toList();

    print('Lista takmicara ${takmicari}');

    for (var obavijest in listaSvih) {
      for (var profil in takmicari ?? []) {
        if (obavijest.kandidatId != null &&
            obavijest.kandidatId == profil.kandidatId) {
          listaKorisnika.add(obavijest);
          break;
        }
      }
    }

    setState(() {
      obavijesti = listaKorisnika;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moje obavijesti",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : obavijesti.isEmpty
          ? const Center(child: Text("Nema novih obavijesti"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: obavijesti
                    .map(
                      (o) => Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      o.sadrzaj ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      o.sadrzaj ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Datum: ${o.datumKreiranja != null ? DateFormat('dd.MM.yyyy').format(o.datumKreiranja!) : '-'}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  // Potvrda prije brisanja
                                  bool? confirmed = await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Potvrdi brisanje'),
                                      content: const Text(
                                        'Da li ste sigurni da želite obrisati obavijest?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Ne'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text('Da'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    try {
                                      bool deleted = await _obavijestProvider
                                          .delete(o.id!);
                                      if (deleted) {
                                        setState(() {
                                          obavijesti.remove(o);
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Obavijest obrisana'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Greška prilikom brisanja: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
