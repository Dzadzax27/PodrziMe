import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podrzime_admin/models/uspjesnaPrica.dart';
import 'package:podrzime_admin/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_admin/screens/home_page.dart';
import 'package:podrzime_admin/screens/pregled_uspjesnih_prica.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DodajUspjesnuPricu extends StatefulWidget {
  UspjesnaPrica? uspjesnaPrica;
  DodajUspjesnuPricu({super.key, this.uspjesnaPrica});

  @override
  State<DodajUspjesnuPricu> createState() => _DodajUspjesnuPricu();
}

class _DodajUspjesnuPricu extends State<DodajUspjesnuPricu> {
  final _formKey = GlobalKey<FormBuilderState>();
  late UspjesnaPricaProvider _uspjesnaPricaProvider;
  Map<String, dynamic> _initialValue = {};

  File? _imageData;
  final _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uspjesnaPricaProvider = context.read<UspjesnaPricaProvider>();
  }

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naslovPrice': widget.uspjesnaPrica?.naslovPrice,
      'prica': widget.uspjesnaPrica?.prica,
      'ukupnaDonacija': widget.uspjesnaPrica?.ukupnaDonacija,
      'slika': widget.uspjesnaPrica?.slika,
    };
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageData = File(image.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var formValues = Map<String, dynamic>.from(_formKey.currentState!.value);

      if (_imageData != null) {
        var bytes = await _imageData!.readAsBytes();
        formValues['slika'] = base64Encode(bytes);
      } else if (widget.uspjesnaPrica?.slika != null) {
        formValues['slika'] = widget.uspjesnaPrica!.slika;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Molimo odaberite sliku')));
        return;
      }

      // Insert via provider
      await _uspjesnaPricaProvider.insert(formValues);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Uspješna priča dodana!')));

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PregledUspjesnihPrica()),
      ); // zatvori ekran nakon dodavanja
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Scaffold(
        appBar: AppBar(title: const Text('Dodaj uspješnu priču')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Naslov
                  FormBuilderTextField(
                    name: 'naslovPrice',
                    decoration: const InputDecoration(
                      labelText: 'Naslov',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Naslov je obavezan',
                      ),
                      FormBuilderValidators.maxLength(
                        100,
                        errorText: 'Maksimalno 100 karaktera',
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Priča
                  FormBuilderTextField(
                    name: 'prica',
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Priča',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Priča je obavezna',
                      ),
                      FormBuilderValidators.minLength(
                        10,
                        errorText: 'Priča mora imati barem 10 karaktera',
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Ukupna donacija
                  FormBuilderTextField(
                    name: 'ukupnaDonacija',
                    decoration: const InputDecoration(
                      labelText: 'Ukupna donacija',
                      prefixIcon: Icon(Icons.monetization_on),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Ukupna donacija je obavezna',
                      ),
                      FormBuilderValidators.numeric(
                        errorText: 'Unesite validan broj',
                      ),
                      FormBuilderValidators.min(
                        0,
                        errorText: 'Vrijednost mora biti pozitivna',
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Image picker
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Odaberi sliku'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _imageData != null
                          ? FutureBuilder<Uint8List>(
                              future: _imageData!.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Greška pri učitavanju slike',
                                  );
                                } else {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        snapshot.data!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          : widget.uspjesnaPrica?.slika != null
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(
                                    widget.uspjesnaPrica!.slika!
                                        .split(',')
                                        .last,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const Text(
                              'Nije odabrana slika',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Dodaj priču',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
