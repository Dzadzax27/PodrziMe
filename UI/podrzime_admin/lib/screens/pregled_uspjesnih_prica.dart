import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/komentar.dart';
import 'package:podrzime_admin/models/search_result.dart';
import 'package:podrzime_admin/models/uspjesnaPrica.dart';
import 'package:podrzime_admin/providers/komentar_provider.dart';
import 'package:podrzime_admin/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_admin/screens/dodaj_uspjesnu_pricu.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class PregledUspjesnihPrica extends StatefulWidget {
  const PregledUspjesnihPrica({super.key});

  @override
  State<PregledUspjesnihPrica> createState() => _PregledUspjesnihPrica();
}

class _PregledUspjesnihPrica extends State<PregledUspjesnihPrica> {
  late UspjesnaPricaProvider _uspjesnaPricaProvider;
  late KomentarProvider _komentarProvider;
  late SearchResult<UspjesnaPrica> listOfUsojesnaPrica;
  List<Komentar> komentari = [];
  List<UspjesnaPrica> filteredListOfUspjesnaPrica = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uspjesnaPricaProvider = context.read<UspjesnaPricaProvider>();
    _komentarProvider = context.read<KomentarProvider>();
    setUspjesnaPrica();
    ucitajKomentare();
  }

  Future<List<Komentar>> fetchKomentari(int? uspjesnaPricaId) async {
    var lista = await _komentarProvider.get(); // await jer je Future
    final komentari = (lista.result ?? [])
        .where((k) => k.uspjesnaPricaId == uspjesnaPricaId)
        .toList();
    return komentari;
  }

  Future<void> setUspjesnaPrica() async {
    try {
      var data = await _uspjesnaPricaProvider.get();
      setState(() {
        listOfUsojesnaPrica = data;
        filteredListOfUspjesnaPrica = data.result ?? [];
        isLoading = false; // hide loader
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Pregled uspjesnih prica',
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DodajUspjesnuPricu()),
              );
            },
            child: const Text('Dodaj novu uspjesnu pricu'),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildForm()),
        ],
      ),
    );
  }

  Widget _buildForm() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredListOfUspjesnaPrica.isEmpty) {
      return const Center(child: Text('Nema uspješnih priča za prikaz.'));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: filteredListOfUspjesnaPrica.length,
        itemBuilder: (context, index) {
          final e = filteredListOfUspjesnaPrica[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ExpansionTile(
              leading: e.slika != null && e.slika!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(e.slika!.split(',').last),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image_not_supported, size: 40),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      e.naslovPrice,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeletePricu(e),
                  ),
                ],
              ),
              children: [
                // ostatak ExpansionTile (tekst, Divider, komentari)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(e.prica),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Komentari:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                _buildKomentare(e.uspjesnaPricaId),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> ucitajKomentare() async {
    var filter = {'isUspjesnaPricaIncluded': false, 'isKorisnikIncluded': true};
    final result = await _komentarProvider.get(filter: filter);

    setState(() {
      komentari = result.result ?? [];
    });
  }

  Widget _buildKomentare(int? uspjesnaPricaId) {
    if (uspjesnaPricaId == null) return const SizedBox();

    print('Pricaa ${uspjesnaPricaId}');

    return FutureBuilder<List<Komentar>>(
      future: fetchKomentari(
        uspjesnaPricaId,
      ), // async funkcija koja vraća komentare za tu priču
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Greška prilikom učitavanja komentara: ${snapshot.error}',
            ),
          );
        }

        final mojiKomentari = snapshot.data ?? [];

        if (mojiKomentari.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Nema komentara za prikaz.'),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: mojiKomentari.map((k) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Text(
                        k.korisnik?.korisnickoIme?.substring(0, 1) ?? 'A',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            k.korisnik?.korisnickoIme ?? 'Annonymus',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            k.komentar1 ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteKomentar(k),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _confirmDeletePricu(UspjesnaPrica prica) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Brisanje priče'),
        content: const Text('Da li ste sigurni da želite obrisati ovu priču?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              var komentariZaBrisanje = komentari
                  .where((k) => k.uspjesnaPricaId == prica.uspjesnaPricaId)
                  .toList();

              for (var k in komentariZaBrisanje) {
                await _komentarProvider.delete(k.komentarId!);
                komentari.remove(k);
              }

              await _uspjesnaPricaProvider.delete(prica.uspjesnaPricaId!);
              setState(() {
                filteredListOfUspjesnaPrica.remove(prica);
              });
              await _uspjesnaPricaProvider.delete(prica.uspjesnaPricaId!);
              setState(() {
                filteredListOfUspjesnaPrica.remove(prica);
              });
            },
            child: const Text('Obriši', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteKomentar(Komentar komentar) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Brisanje komentara'),
        content: const Text(
          'Da li ste sigurni da želite obrisati ovaj komentar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // zatvori dialog
              await _komentarProvider.delete(komentar.komentarId!);
              setState(() {
                komentari.remove(komentar);
              });
            },
            child: const Text('Obriši', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
