import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podrzime_admin/models/uspjesnaPrica.dart';
import 'package:podrzime_admin/providers/uspjesnaPrica_provider.dart';
import 'package:provider/provider.dart';

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
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
      }

      // Insert via provider
      await _uspjesnaPricaProvider.insert(formValues);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Success Story Added!')));
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Scaffold(
        appBar: AppBar(title: const Text('Dodaj uspjesnu pricu')),
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
                  // Title
                  FormBuilderTextField(
                    name: 'naslovPrice',
                    decoration: const InputDecoration(
                      labelText: 'Naslov',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  FormBuilderTextField(
                    name: 'prica',
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Prica',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Author
                  FormBuilderTextField(
                    name: 'ukupnaDonacija',
                    decoration: const InputDecoration(
                      labelText: 'Ukupna donacija',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image picker
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Upload Image'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _imageData != null
                          ? FutureBuilder<Uint8List>(
                              future: _imageData!
                                  .readAsBytes(), // read bytes from File
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
                                  return const Text('Error loading image');
                                } else {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
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
                          : const Text(
                              'No image selected',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Add Story',
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
