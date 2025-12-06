import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/screens/pregled_takmicara.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class PregledSvihTakmicara extends StatefulWidget {
  const PregledSvihTakmicara({Key? key}) : super(key: key);

  @override
  State<PregledSvihTakmicara> createState() => _PregledSvihTakmicaraState();
}

class _PregledSvihTakmicaraState extends State<PregledSvihTakmicara> {
  late TakmicarProvider _takmicarProvider;
  List<Takmicar> filteredList = [];
  List<Takmicar> allTakmicari = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _takmicarProvider = context.read<TakmicarProvider>();
    _getKorisnici();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getKorisnici();
    });
  }

  void _filterTakmicari(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredList = allTakmicari.where((takmicar) {
        final fullName = '${takmicar.ime} ${takmicar.prezime}'.toLowerCase();
        return fullName.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Naslovna strana",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Field
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterTakmicari,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: "Pretraga po imenu ili prezimenu",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(child: _buildTable()),
          ],
        ),
      ),
    );
  }

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
                        "${e.ime} ${e.prezime}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.kategorija?.nazivKategorije ?? "",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
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
                Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        e.odobren = false;
                        await _takmicarProvider.update(e.kandidatId!, e);
                        await _getKorisnici();
                      },
                      child: const Text("Izbrisi"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getKorisnici() async {
    var response = await _takmicarProvider.get();
    setState(() {
      allTakmicari = (response.result ?? [])
          .where((item) => item.odobren == true)
          .toList();
      filteredList = allTakmicari;
    });
  }
}
