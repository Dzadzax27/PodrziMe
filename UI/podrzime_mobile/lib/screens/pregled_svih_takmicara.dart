import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/screens/pregled_takmicara.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';

class PregledSvihTakmicara extends StatefulWidget {
  const PregledSvihTakmicara({Key? key}) : super(key: key);

  @override
  State<PregledSvihTakmicara> createState() => _PregledSvihTakmicaraState();
}

class _PregledSvihTakmicaraState extends State<PregledSvihTakmicara> {
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
    _getKorisniciWithoutFilter();
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
      title: "Pregled kandidata",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSearchSection(),
            const SizedBox(height: 20),
            if (filteredList.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "Nema pronađenih takmičara.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              ...filteredList.map((e) => _buildTakmicarCard(e)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🔍 Pretraga takmičara",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 50, 70, 90),
              ),
            ),
            const SizedBox(height: 20),

            // Ime
            TextField(
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
                hintText: "Unesi ime",
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Prezime
            TextField(
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
                hintText: "Unesi prezime",
                prefixIcon: const Icon(Icons.badge, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dugme za pretragu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  var filter = {
                    'ime': _ftsEditingController.text,
                    'fts': _sifraController.text,
                    'isKategorijaIncluded': true,
                  };
                  _getKorisnici(filter);
                },
                icon: const Icon(Icons.search),
                label: const Text(
                  "Pretraži",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 191, 69, 60),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 12),

            const Text(
              "Filtriraj po kategoriji",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 50, 70, 90),
              ),
            ),
            const SizedBox(height: 12),

            _buildFilterButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _filterButton(
          label: "Sport",
          icon: Icons.sports_soccer_rounded,
          selected: isSportSelected,
          selectedColor: const Color.fromARGB(255, 136, 163, 185),
          onTap: () => _toggleFilter("Sport"),
        ),
        _filterButton(
          label: "Umjetnost",
          icon: Icons.palette,
          selected: isArtSelected,
          selectedColor: const Color.fromARGB(255, 243, 131, 131),
          onTap: () => _toggleFilter("Umjetnost"),
        ),
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

  Widget _buildTakmicarCard(Takmicar e) {
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

  Future<void> _getKorisnici(Map<String, dynamic> filter) async {
    var response = await _takmicarProvider.get(filter);

    setState(() {
      filteredList = (response ?? [])
          .where((item) => item.odobren == true)
          .toList();
    });
  }

  Future<void> _getKorisniciWithoutFilter() async {
    var filter = {
      'fts': _ftsEditingController.text,
      'sifra': _sifraController.text,
      'isKategorijaIncluded': true,
    };
    var response = await _takmicarProvider.get(filter);
    setState(() {
      _allItems = (response ?? [])
          .where((item) => item.odobren == true)
          .toList();

      filteredList = _allItems;
    });
  }
}
