import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/donacija.dart';
import 'package:podrzime_admin/models/search_result.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

SearchResult<Takmicar>? resultOfKandidats = null;
late TakmicarProvider _takmicarProvider;

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _takmicarProvider = context.read<TakmicarProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _takmicarProvider = context.read<TakmicarProvider>();
    return MasterScreenWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lista proizvoda placeholder"),
          const SizedBox(height: 8),
          _buildSearch(),
          ElevatedButton(
            onPressed: () async {
              var filter = {
                'fts': _ftsEditingController.text,
                'sifra': _sifraController.text,
              };
              var result = await _takmicarProvider.get(filter: filter);

              setState(() {
                resultOfKandidats = result;
              });

              print(
                resultOfKandidats?.result
                    .map((e) => "${e.ime} ${e.prezime} - ${e.omeni}")
                    .toList(),
              );
            },
            child: const Text("Pretraga"), // better label than "Nazad"
          ),
          _buildTable(),
        ],
      ),
    );
  }
}

Widget _buildTable() {
  return Expanded(
    child: DataTable(
      columns: [
        DataColumn(label: Text("Ime")),
        DataColumn(label: Text("Prezime")),
        DataColumn(label: Text("o meni")),
        DataColumn(label: Text("broj telefona")),
      ],
      rows:
          resultOfKandidats?.result
              .map(
                (e) => DataRow(
                  cells: [
                    DataCell(Text(e.ime ?? "")),
                    DataCell(Text(e.prezime ?? "")),
                    DataCell(Text(e.omeni ?? "")),
                    DataCell(Text(e.brojTelefona.toString())),
                  ],
                ),
              )
              .toList()
              .cast<DataRow>() ??
          [],
    ),
  );
}

TextEditingController _ftsEditingController = TextEditingController();
TextEditingController _sifraController = TextEditingController();

Widget _buildSearch() {
  return Padding(
    padding: const EdgeInsets.all(9.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ftsEditingController,
            decoration: InputDecoration(labelText: "Naziv ili sifra"),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _sifraController,
            decoration: InputDecoration(labelText: "Šifra"),
          ),
        ),
      ],
    ),
  );
}
