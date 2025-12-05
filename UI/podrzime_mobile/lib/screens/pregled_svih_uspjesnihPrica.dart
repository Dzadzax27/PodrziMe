import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/modals/uspjesnaPrica.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_mobile/screens/pregled_takmicara.dart';
import 'package:podrzime_mobile/screens/pregled_uspjesnih_prica.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';

class PregledSvihUspjesnihPrica extends StatefulWidget {
  const PregledSvihUspjesnihPrica({Key? key}) : super(key: key);

  @override
  State<PregledSvihUspjesnihPrica> createState() =>
      _PregledSvihUspjesnihPricaState();
}

class _PregledSvihUspjesnihPricaState extends State<PregledSvihUspjesnihPrica> {
  late UspjesnaPricaProvider _uspjesnaPricaProvider;
  List<UspjesnaPrica> filteredList = [];

  final TextEditingController _ftsEditingController = TextEditingController();
  final TextEditingController _sifraController = TextEditingController();

  bool isSportSelected = false;
  bool isArtSelected = false;
  bool isEducationSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uspjesnaPricaProvider = context.read<UspjesnaPricaProvider>();
    _getKorisnici();
  }

  @override
  void dispose() {
    _ftsEditingController.dispose();
    _sifraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Uspjesne price",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(child: _buildTable()),
          ],
        ),
      ),
    );
  }

  /// 📋 Table/List of Participants
  Widget _buildTable() {
    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          "Nema pronađenih takmičara.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final e = filteredList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                        "${e.naslovPrice}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PregledUspjesnihPrica(e),
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
      },
    );
  }

  Future<void> _getKorisnici() async {
    var response = await _uspjesnaPricaProvider.get();
    setState(() {
      filteredList = response ?? [];
    });
    print('FilteredList  $filteredList');
  }
}
