import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/search_result.dart';
import 'package:podrzime_admin/models/uspjesnaPrica.dart';
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
  late SearchResult<UspjesnaPrica> listOfUsojesnaPrica;
  List<UspjesnaPrica> filteredListOfUspjesnaPrica = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uspjesnaPricaProvider = context.read<UspjesnaPricaProvider>();
    setUspjesnaPrica();
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
              title: Text(
                e.naslovPrice,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(e.prica),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
