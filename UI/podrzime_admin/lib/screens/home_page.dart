import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/korisnik.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/screens/pregled_takmicara.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late TakmicarProvider _takmicarProvider;
  List<Takmicar> filteredList = [];
  List<Takmicar> _allItems = [];

  final TextEditingController _ftsEditingController = TextEditingController();
  final TextEditingController _sifraController = TextEditingController();

  bool isSportSelected = false;
  bool isArtSelected = false;
  bool isEducationSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _takmicarProvider = context.read<TakmicarProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getKorisniciWithoutFilter();
    });
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
      title: "Zahtjev za kandidatima",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchSection(),
            const SizedBox(height: 20),
            Expanded(child: _buildTable()),
          ],
        ),
      ),
    );
  }

  /// 🔍 Nicer Search + Filter UI
  Widget _buildSearchSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pretraga takmičara",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 50, 70, 90),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ftsEditingController,
                    onChanged: (value) {
                      var filter = {
                        'ime': value,
                        'fts': _sifraController.text,
                        'isKategorijaIncluded': true,
                      };
                      _getKorisnici(filter);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      labelText: "Ime",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _sifraController,
                    onChanged: (value) {
                      var filter = {
                        'ime': _ftsEditingController.text,
                        'fts': value,
                        'isKategorijaIncluded': true,
                      };
                      _getKorisnici(filter);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.confirmation_number_outlined,
                      ),
                      labelText: "Prezime",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    var filter = {
                      'ime': _ftsEditingController.text,
                      'fts': _sifraController.text,
                      'isKategorijaIncluded': true,
                    };
                    _getKorisnici(filter);
                  },
                  icon: const Icon(Icons.search),
                  label: const Text("Pretraga"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 191, 69, 60),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFilterButtons(),
          ],
        ),
      ),
    );
  }

  /// 🧭 Cleaner Filter Buttons
  Widget _buildFilterButtons() {
    return Row(
      children: [
        _filterButton(
          label: "Sport",
          icon: Icons.sports_soccer_rounded,
          selected: isSportSelected,
          selectedColor: const Color.fromARGB(255, 136, 163, 185),
          onTap: () => _toggleFilter("Sport"),
        ),
        const SizedBox(width: 12),
        _filterButton(
          label: "Umjetnost",
          icon: Icons.palette,
          selected: isArtSelected,
          selectedColor: const Color.fromARGB(255, 243, 131, 131),
          onTap: () => _toggleFilter("Umjetnost"),
        ),
        const SizedBox(width: 12),
        _filterButton(
          label: "Edukacija",
          icon: Icons.school,
          selected: isEducationSelected,
          selectedColor: const Color.fromARGB(255, 190, 233, 190),
          onTap: () => _toggleFilter("Edukacija"),
        ),
      ],
    );
  }

  Widget _filterButton({
    required String label,
    required IconData icon,
    required bool selected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: selected ? Colors.black : Colors.grey[700]),
      label: Text(
        label,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? selectedColor : Colors.white,
        side: const BorderSide(color: Color.fromARGB(50, 0, 0, 0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: selected ? 4 : 1,
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
                        e.odobren = true;
                        await _takmicarProvider.update(
                          e.kandidatId!,
                          e.toJson(),
                        );
                        _getKorisniciWithoutFilter();
                      },
                      child: const Text("Prihvati"),
                    ),
                    TextButton(
                      onPressed: () {
                        e.odobren = false;
                        _takmicarProvider.update(e.kandidatId!, e.toJson());
                        _getKorisniciWithoutFilter();
                      },
                      child: const Text(
                        "Odbij",
                        style: TextStyle(color: Colors.red),
                      ),
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

  void _toggleFilter(String category) {
    setState(() {
      if (category == "Sport") {
        isSportSelected = !isSportSelected;
      } else if (category == "Umjetnost") {
        isArtSelected = !isArtSelected;
      } else if (category == "Edukacija") {
        isEducationSelected = !isEducationSelected;
      }

      final selectedCount = [
        isSportSelected,
        isArtSelected,
        isEducationSelected,
      ].where((x) => x).length;

      if ((isSportSelected || isArtSelected || isEducationSelected) &&
          selectedCount == 1) {
        filteredList = _allItems
            .where(
              (item) =>
                  (isSportSelected &&
                      item.kategorija?.nazivKategorije == 'Sport') ||
                  (isArtSelected &&
                      item.kategorija?.nazivKategorije == 'Umjetnost') ||
                  (isEducationSelected &&
                      item.kategorija?.nazivKategorije == 'Edukacija'),
            )
            .toList();
      } else {
        if (selectedCount > 1) {
          filteredList = [];
        } else {
          var filter = {
            'fts': _ftsEditingController.text,
            'sifra': _sifraController.text,
            'isKategorijaIncluded': true,
          };
          _getKorisnici(filter);
        }
      }
    });
  }

  void _getKorisnici(Map<String, dynamic> filter) async {
    var response = await _takmicarProvider.get(filter: filter);
    setState(() {
      filteredList = (response.result ?? [])
          .where((item) => item.odobren == null)
          .toList();
    });
  }

  Future<void> _getKorisniciWithoutFilter() async {
    var filter = {
      'fts': _ftsEditingController.text,
      'sifra': _sifraController.text,
      'isKategorijaIncluded': true,
    };
    var response = await _takmicarProvider.get(filter: filter);
    setState(() {
      _allItems = (response.result ?? [])
          .where((item) => item.odobren == null)
          .toList();

      filteredList = _allItems;
    });
  }
}
