import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podrzime_mobile/modals/kategorija.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';
import 'package:podrzime_mobile/providers/kategorija_provider.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';

class AddTakmicar extends StatefulWidget {
  final Takmicar? takmicar;
  const AddTakmicar({super.key, this.takmicar});

  @override
  State<AddTakmicar> createState() => _AddTakmicarState();
}

class _AddTakmicarState extends State<AddTakmicar> {
  final _formKey = GlobalKey<FormBuilderState>();
  File? _selectedImage;

  late TakmicarProvider _takmicarProvider;
  late TakmicarProfilProvider _takmicarProfilProvider;
  late KategorijaProvider _kategorijaProvider;
  TakmicarProfil? korisnikProfil;

  List<Kategorija>? kategorije = [];
  Map<String, dynamic> _initialValue = {};
  DateTime? datumRodjenja;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _takmicarProvider = context.read<TakmicarProvider>();
    _kategorijaProvider = context.read<KategorijaProvider>();
    _takmicarProfilProvider = context.read<TakmicarProfilProvider>();
    _loadKategorije();
  }

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.takmicar?.ime ?? '',
      'prezime': widget.takmicar?.prezime ?? '',
      'email': widget.takmicar?.email ?? '',
      'omeni': widget.takmicar?.omeni ?? '',
      'uspjesi': widget.takmicar?.uspjesi ?? '',
      'link': widget.takmicar?.link ?? '',
      'brojTelefona': widget.takmicar?.brojTelefona ?? '',
      'zeljenaDonacija': widget.takmicar?.zeljenaDonacija?.toString() ?? '',
      'kategorijaId': widget.takmicar?.kategorijaId,
      'slika': widget.takmicar?.slika,
    };
  }

  Future<void> _loadKategorije() async {
    final result = await _kategorijaProvider.get();
    for (var k in result) {
      print('Loaded kategorija: ${k.kategorijaId} - ${k.nazivKategorije}');
    }
    setState(() => {kategorije = result, print('Result ${kategorije}')});
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _selectedImage = File(image.path));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: datumRodjenja ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => datumRodjenja = picked);
  }

  void _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formValues = Map<String, dynamic>.from(
        _formKey.currentState!.value,
      );

      if (datumRodjenja != null) {
        formValues['datumRodjenja'] = datumRodjenja!
            .toIso8601String()
            .split('T')
            .first;
      }

      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        formValues['slika'] = base64Encode(bytes);
      }

      var logiraniKorisnik = Logiranikorisnik.korisnik;
      var korisnikProfilList = await _takmicarProfilProvider.get();

      final lista = korisnikProfilList
          .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
          .toList();

      setState(() {
        korisnikProfil = lista.isNotEmpty ? lista.first : null;
      });

      formValues['takmicarProfilId'] = korisnikProfil?.takmicarProfilId;
      await _takmicarProvider.insert(formValues);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Takmičar uspješno dodan!')));
    }
  }

  void loadKorisnikProfil(formValues) async {
    var korisnikProfilList = await _takmicarProfilProvider.get();

    final lista = korisnikProfilList
        .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
        .toList();

    setState(() {
      korisnikProfil = lista.isNotEmpty ? lista.first : null;
    });

    var updatekorisnikProfil = {
      "ime": korisnikProfil!.ime,
      "prezime": korisnikProfil!.prezime,
      "datumRodjenja": korisnikProfil!.datumRodjenja!.toIso8601String(),
      "kandidatIds": [formValues['kandidatId']],
    };

    int idForUpdate = korisnikProfil?.takmicarProfilId ?? 0;
    await _takmicarProfilProvider.update(idForUpdate, updatekorisnikProfil);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Dodaj Takmičara",
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                "+ Dodajte sliku",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                FormBuilderTextField(
                  name: "ime",
                  decoration: InputDecoration(labelText: "Ime"),
                ),
                FormBuilderTextField(
                  name: "prezime",
                  decoration: InputDecoration(labelText: "Prezime"),
                ),
                FormBuilderTextField(
                  name: "email",
                  decoration: InputDecoration(labelText: "Email"),
                ),
                FormBuilderDropdown<int>(
                  name: 'kategorijaId',
                  decoration: const InputDecoration(labelText: "Kategorija"),
                  items: (kategorije ?? [])
                      .where((k) => k.kategorijaId != null)
                      .map<DropdownMenuItem<int>>(
                        (k) => DropdownMenuItem<int>(
                          value: k.kategorijaId!,
                          child: Text(k.nazivKategorije ?? 'Nepoznato'),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),

                FormBuilderTextField(
                  name: "omeni",
                  decoration: InputDecoration(labelText: "O meni"),
                ),
                FormBuilderTextField(
                  name: "uspjesi",
                  decoration: InputDecoration(labelText: "Uspjesi"),
                ),
                FormBuilderTextField(
                  name: "link",
                  decoration: InputDecoration(labelText: "Link"),
                ),
                const SizedBox(height: 8),
                if (_selectedImage != null)
                  FormBuilderTextField(
                    name: "brojTelefona",
                    decoration: InputDecoration(labelText: "Broj telefona"),
                  ),
                FormBuilderTextField(
                  name: "zeljenaDonacija",
                  decoration: InputDecoration(labelText: "Željena donacija"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Dodaj takmičara"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
