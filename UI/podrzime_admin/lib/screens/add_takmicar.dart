import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:podrzime_admin/models/kategorija.dart';
import 'package:podrzime_admin/models/search_result.dart';
import 'package:podrzime_admin/models/takmicar.dart';
import 'package:podrzime_admin/providers/kategorija_provider.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class AddTakmicar extends StatefulWidget {
  Takmicar? takmicar;
  AddTakmicar({super.key, this.takmicar});

  @override
  State<AddTakmicar> createState() => _AddTakmicarState();
}

File? _selectedImage;

class _AddTakmicarState extends State<AddTakmicar> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController imeController = TextEditingController();
  final TextEditingController prezimeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController omeniController = TextEditingController();
  final TextEditingController uspjesiController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController brojTelefonaController = TextEditingController();
  final TextEditingController zeljenaDonacijaController =
      TextEditingController();
  late TextEditingController _selectedKategorijaId = TextEditingController();
  late TakmicarProvider _takmicarProvider;
  late KategorijaProvider _kategorijaProvider;
  SearchResult<Kategorija>? kategorije;
  Map<String, dynamic> _initialValue = {};
  DateTime? datumRodjenja;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _takmicarProvider = context.read<TakmicarProvider>();
    _kategorijaProvider = context.read<KategorijaProvider>();
    _loadKategorije();
  }

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.takmicar?.ime,
      'prezime': widget.takmicar?.prezime,
      'email': widget.takmicar?.email,
      'omeni': widget.takmicar?.omeni,
      'uspjesi': widget.takmicar?.uspjesi,
      'link': widget.takmicar?.link,
      'brojTelefona': widget.takmicar?.brojTelefona,
      'zeljena donacija': widget.takmicar?.zeljenaDonacija?.toString(),
      'kategorijaId': widget.takmicar?.kategorijaId,
      'slika': widget.takmicar?.slika,
    };
  }

  @override
  void dispose() {
    imeController.dispose();
    prezimeController.dispose();
    emailController.dispose();
    omeniController.dispose();
    uspjesiController.dispose();
    linkController.dispose();
    brojTelefonaController.dispose();
    zeljenaDonacijaController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Convert to Map<String, dynamic>
      var formValues = Map<String, dynamic>.from(_formKey.currentState!.value);

      // Add formatted date
      if (datumRodjenja != null) {
        formValues['datumRodjenja'] = datumRodjenja!
            .toIso8601String()
            .split('T')
            .first;
      }

      // Attach image file
      if (_selectedImage != null) {
        var bytes = await _selectedImage!.readAsBytes();
        formValues['slika'] = base64Encode(bytes);
      }

      // Insert via provider
      await _takmicarProvider.insert(formValues);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Takmičar ${imeController.text} ${prezimeController.text} uspješno dodan!",
          ),
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: datumRodjenja ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        datumRodjenja = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(title: "Dodaj Takmičara", child: _buildForm());
  }

  Future<void> _loadKategorije() async {
    var result = await _kategorijaProvider.get();
    setState(() {
      kategorije = result;
    });
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "Ime"),
                name: "ime",
              ),
            ),

            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "Prezime"),
                name: "prezime",
              ),
            ),

            FormBuilderDropdown<int>(
              name: 'kategorijaId',
              decoration: const InputDecoration(
                labelText: "Kategorija",
                border: OutlineInputBorder(),
              ),
              items: (kategorije?.result ?? [])
                  .map<DropdownMenuItem<int>>(
                    (k) => DropdownMenuItem<int>(
                      value: k.kategorijaId!,
                      child: Text(k.nazivKategorije ?? 'Nepoznato'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _buildTextField(
                    _selectedKategorijaId,
                    value?.toString() ?? '',
                  );
                });
              },
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "Email"),
                name: "email",
              ),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: FormBuilderTextField(
                  decoration: InputDecoration(
                    labelText: "Datum rođenja",
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  name: "datumRodjenja",
                  controller: TextEditingController(
                    text: datumRodjenja == null
                        ? ""
                        : "${datumRodjenja!.day}.${datumRodjenja!.month}.${datumRodjenja!.year}",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "o meni"),
                name: "omeni",
              ),
            ),

            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "uspjesi"),
                name: "usojesi",
              ),
            ),

            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "link"),
                name: "link",
              ),
            ),

            GestureDetector(
              onTap: pickImage,
              child: AbsorbPointer(
                child: FormBuilderTextField(
                  name: "slika",
                  decoration: InputDecoration(
                    labelText: "Slika",
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.image),
                  ),
                  controller: TextEditingController(
                    text: _selectedImage != null
                        ? "Odabrana: ${_selectedImage!.path.split('/').last}"
                        : "",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedImage != null)
              SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),

            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "Broj telefona"),
                name: "brojTelefona",
              ),
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(labelText: "zeljena donacija"),
                name: "zeljena donacija",
              ),
            ),

            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Dodaj takmičara"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
