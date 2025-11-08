import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:podrzime_mobile/modals/donor.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';
import 'package:podrzime_mobile/modals/uloga.dart';
import 'package:podrzime_mobile/providers/donor_provider.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/providers/uloga_provider.dart';
import 'package:podrzime_mobile/screens/login_page.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DodajTakmicarProfil extends StatefulWidget {
  final dynamic ulogaId;
  final TakmicarProfil? takmicarProfil;
  const DodajTakmicarProfil({super.key, this.ulogaId, this.takmicarProfil});

  @override
  State<DodajTakmicarProfil> createState() => _DodajTakmicarProfilState();
}

class _DodajTakmicarProfilState extends State<DodajTakmicarProfil> {
  final _formKey = GlobalKey<FormBuilderState>();

  late TakmicarProfilProvider _takmicarProfilProvider;
  late UlogaProvider _ulogaProvider;
  late int selectedulogaId;

  List<Uloga>? uloge = [];
  Map<String, dynamic> _initialValue = {};
  DateTime? datumRodjenja;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _takmicarProfilProvider = context.read<TakmicarProfilProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
  }

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.takmicarProfil?.ime ?? '',
      'prezime': widget.takmicarProfil?.prezime ?? '',
      'datumRodjenja': widget.takmicarProfil?.datumRodjenja,
    };
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

      if (formValues['datumRodjenja'] != null &&
          formValues['datumRodjenja'] is DateTime) {
        formValues['datumRodjenja'] = (formValues['datumRodjenja'] as DateTime)
            .toIso8601String()
            .split('T')
            .first;
      }

      formValues['korisnikId'] = widget.ulogaId;

      await _takmicarProfilProvider.insert(formValues);

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Kreiraj profil",
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.black45,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email
                    FormBuilderTextField(
                      name: "ime",
                      decoration: InputDecoration(
                        labelText: "Ime",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.man),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ime je obavezno",
                        ),
                        FormBuilderValidators.minLength(
                          2,
                          errorText:
                              "Ime mora sadrzavati minimalno 2 karaktera",
                        ),
                      ]),
                    ),

                    const SizedBox(height: 16),

                    // Username
                    FormBuilderTextField(
                      name: "prezime",
                      decoration: InputDecoration(
                        labelText: "Prezime",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Prezime je obavezno",
                        ),
                        FormBuilderValidators.minLength(
                          2,
                          errorText:
                              "Prezime mora sadrzavati minimalno 2 karaktera",
                        ),
                      ]),
                    ),

                    const SizedBox(height: 16),

                    const SizedBox(height: 16),
                    FormBuilderField<DateTime>(
                      name: 'datumRodjenja',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Datum rođenja je obavezan",
                        ),
                      ]),
                      builder: (field) {
                        return GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: field.value ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) field.didChange(picked);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                              errorText: field
                                  .errorText, // <-- show validation message
                            ),
                            child: Text(
                              field.value != null
                                  ? '${field.value!.day.toString().padLeft(2, '0')}.'
                                        '${field.value!.month.toString().padLeft(2, '0')}.'
                                        '${field.value!.year}'
                                  : 'Odaberite datum',
                              style: TextStyle(
                                color: field.value != null
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Submit Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Dodaj licne podatke",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
