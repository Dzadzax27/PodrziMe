import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/screens/pregled_takmicara.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class PregledSvihTakmicara extends StatefulWidget {
  final String? initialCategory;

  const PregledSvihTakmicara({Key? key, this.initialCategory})
    : super(key: key);

  @override
  State<PregledSvihTakmicara> createState() => _PregledSvihTakmicaraState();
}

class _PregledSvihTakmicaraState extends State<PregledSvihTakmicara> {
  late TakmicarProvider _takmicarProvider;
  late DonacijaProvider _donacijaProvider;

  List<Takmicar> allTakmicari = [];
  List<Takmicar> filteredList = [];
  Map<int, int> _donacijePoTakmicaru = {}; // kandidatId -> suma donacija

  final TextEditingController _searchController = TextEditingController();

  bool isSportSelected = false;
  bool isArtSelected = false;
  bool isEducationSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _takmicarProvider = context.read<TakmicarProvider>();
    _donacijaProvider = context.read<DonacijaProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getKorisnici();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 📡 API
  Future<void> _getKorisnici() async {
    var filter = {'isKategorijaIncluded': true};
    var response = await _takmicarProvider.get(filter: filter);

    var takmicari = (response.result ?? [])
        .where((item) => item.odobren == true)
        .toList();

    // Učitaj sve donacije i saberi po takmičaru
    var sveDonacije = await _donacijaProvider.get();
    Map<int, int> donacijeMap = {};
    for (var d in sveDonacije.result) {
      if (d.donorId != null) {
        donacijeMap[d.donorId!] =
            (donacijeMap[d.donorId!] ?? 0) + (d.iznosDonacije ?? 0);
      }
    }

    setState(() {
      allTakmicari = takmicari;
      _donacijePoTakmicaru = donacijeMap;

      if (widget.initialCategory != null) {
        isSportSelected = widget.initialCategory == "Sport";
        isArtSelected = widget.initialCategory == "Umjetnost";
        isEducationSelected = widget.initialCategory == "Edukacija";
      }

      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Svi takmičari",
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

  /// 🔍 Search + Filter UI
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
            TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: "Ime ili prezime",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterButtons(),
          ],
        ),
      ),
    );
  }

  /// 🧭 Filter buttons
  Widget _buildFilterButtons() {
    return Row(
      children: [
        _filterButton(
          label: "Sport",
          icon: Icons.sports_soccer,
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
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? selectedColor : Colors.white,
        side: const BorderSide(color: Color.fromARGB(50, 0, 0, 0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: selected ? 4 : 1,
      ),
    );
  }

  /// 📋 List
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

        // Sabiramo donacije po takmičaru
        double goal = (e.zeljenaDonacija ?? 0).toDouble();
        double collected = (_donacijePoTakmicaru[e.kandidatId] ?? 0).toDouble();
        double remaining = (goal - collected).clamp(0, goal);
        double progress = goal > 0 ? collected / goal : 0;

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
                // 🧍 Slika
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

                // 🧾 Info lijevo
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
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                TextButton(
                  onPressed: () async {
                    e.odobren = false;
                    await _takmicarProvider.update(e.kandidatId!, e);
                    await _getKorisnici();
                  },
                  child: const Text("Izbriši"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🧠 Filter logic
  void _toggleFilter(String category) {
    setState(() {
      if (category == "Sport") isSportSelected = !isSportSelected;
      if (category == "Umjetnost") isArtSelected = !isArtSelected;
      if (category == "Edukacija") isEducationSelected = !isEducationSelected;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final selectedCount = [
      isSportSelected,
      isArtSelected,
      isEducationSelected,
    ].where((x) => x).length;

    if (selectedCount > 1) {
      setState(() {
        filteredList = [];
      });
      return;
    }

    filteredList = allTakmicari.where((item) {
      final fullName = "${item.ime} ${item.prezime}".toLowerCase();
      final matchesText = fullName.contains(query);
      bool matchesCategory = true;
      if (selectedCount == 1) {
        if (isSportSelected)
          matchesCategory = item.kategorija?.nazivKategorije == "Sport";
        if (isArtSelected)
          matchesCategory = item.kategorija?.nazivKategorije == "Umjetnost";
        if (isEducationSelected)
          matchesCategory = item.kategorija?.nazivKategorije == "Edukacija";
      }
      return matchesText && matchesCategory;
    }).toList();
  }
}
