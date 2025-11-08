import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:podrzime_mobile/modals/donor.dart';
import 'package:podrzime_mobile/modals/uloga.dart';
import 'package:podrzime_mobile/providers/donor_provider.dart';
import 'package:podrzime_mobile/providers/uloga_provider.dart';
import 'package:podrzime_mobile/screens/login_page.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DodajDonora extends StatefulWidget {
  final dynamic ulogaId;
  final Donor? donor;
  const DodajDonora({super.key, this.ulogaId, this.donor});

  @override
  State<DodajDonora> createState() => _DodajDonoraState();
}

class _DodajDonoraState extends State<DodajDonora> {
  final _formKey = GlobalKey<FormBuilderState>();

  late DonorProvider _donorProvider;
  late UlogaProvider _ulogaProvider;
  late int selectedulogaId;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  List<Uloga>? uloge = [];
  Map<String, dynamic> _initialValue = {};
  DateTime? datumRodjenja;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _donorProvider = context.read<DonorProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _loadUloge();
  }

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.donor?.ime ?? '',
      'prezime': widget.donor?.prezime ?? '',
      'ukupnaDonacija': widget.donor?.ukupnoDonacija ?? '',
      'lozinka': widget.donor?.zanimanje ?? '',
      'datumRodjenja': widget.donor?.datumRodjenja,
    };
  }

  Future<void> _loadUloge() async {
    final result = await _ulogaProvider.get();
    setState(() => uloge = result);
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
            .first; // converts to "yyyy-MM-dd"
      }

      formValues['korisnikId'] = widget.ulogaId;

      await _donorProvider.insert(formValues);

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const LoginPage()));
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
                    // Ime
                    FormBuilderTextField(
                      name: "ime",
                      decoration: InputDecoration(
                        labelText: "Ime *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ime je obavezno polje",
                        ),
                        FormBuilderValidators.minLength(
                          2,
                          errorText: "Ime mora imati najmanje 2 slova",
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Prezime
                    FormBuilderTextField(
                      name: "prezime",
                      decoration: InputDecoration(
                        labelText: "Prezime *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Prezime je obavezno polje",
                        ),
                        FormBuilderValidators.minLength(
                          2,
                          errorText: "Prezime mora imati najmanje 2 slova",
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Zanimanje
                    FormBuilderTextField(
                      name: "zanimanje",
                      decoration: InputDecoration(
                        labelText: "Zanimanje *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.work_outline),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: "Zanimanje je obavezno polje",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Datum rođenja
                    FormBuilderField<DateTime>(
                      name: 'datumRodjenja',
                      validator: (value) {
                        if (value == null) {
                          return "Datum rođenja je obavezan";
                        }
                        if (value.isAfter(DateTime.now())) {
                          return "Datum rođenja ne može biti u budućnosti";
                        }
                        return null;
                      },
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
                              labelText: "Datum rođenja *",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                              errorText: field.errorText,
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

                    const SizedBox(height: 24),

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
                          "Dodaj lične podatke",
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
