import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podrzime_mobile/modals/kategorija.dart';
import 'package:podrzime_mobile/modals/korisnik.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/modals/uloga.dart';
import 'package:podrzime_mobile/providers/kategorija_provider.dart';
import 'package:podrzime_mobile/providers/korisnik_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/providers/uloga_provider.dart';
import 'package:podrzime_mobile/screens/dodaj_TakmicarProfil.dart';
import 'package:podrzime_mobile/screens/dodaj_donora.dart';
import 'package:podrzime_mobile/utils/errorCode.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Registracija extends StatefulWidget {
  final Korisnik? korisnik;
  const Registracija({super.key, this.korisnik});

  @override
  State<Registracija> createState() => _RegistracijaState();
}

class _RegistracijaState extends State<Registracija> {
  final _formKey = GlobalKey<FormBuilderState>();

  late KorisnikProvider _korisnikProvider;
  late UlogaProvider _ulogaProvider;
  int? selectedUlogaId = 0;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  List<Uloga>? uloge = [];
  Map<String, dynamic> _initialValue = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _korisnikProvider = context.read<KorisnikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _loadUloge();
  }

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'email': widget.korisnik?.email ?? '',
      'telefon': widget.korisnik?.telefon ?? '',
      'korisnickoIme': widget.korisnik?.korisnickoIme ?? '',
      'lozinka': widget.korisnik?.lozinka ?? '',
      'lozinkaPotvrda': widget.korisnik?.lozinkaPotvrda ?? '',
      'ulogaId': widget.korisnik?.ulogaId,
    };
  }

  Future<void> _loadUloge() async {
    final result = await _ulogaProvider.get();
    setState(() => {uloge = result});
  }

  void _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formValues = Map<String, dynamic>.from(
        _formKey.currentState!.value,
      );
      var response = await _korisnikProvider.insert(formValues);
      if (ErrorCode.errorUniqueField == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Korisničko ime je već iskorišteno. Molimo odaberite drugo.",
            ),
          ),
        );

        _formKey.currentState?.fields['korisnickoIme']?.invalidate(
          "Korisničko ime je već zauzeto",
        );

        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Korisnik uspješno registrovan!')),
        );

        Uloga? selectedUloga;
        if (uloge != null) {
          try {
            selectedUloga = uloge!.firstWhere(
              (t) => t.ulogaId == selectedUlogaId,
            );
          } catch (e) {
            selectedUloga = null;
          }
        }

        if (selectedUloga?.nazivUloge == 'Donor') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  DodajDonora(ulogaId: response.korisnikId ?? 0),
            ),
          );
        }

        if (selectedUloga?.nazivUloge == 'Takmicar') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  DodajTakmicarProfil(ulogaId: response.korisnikId ?? 0),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Molimo popunite sva obavezna polja.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Registracija",
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
                      name: "email",
                      decoration: InputDecoration(
                        labelText: "Email *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Email je obavezan",
                        ),
                        FormBuilderValidators.email(
                          errorText: "Unesite ispravan email",
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Role Dropdown
                    FormBuilderDropdown<int>(
                      name: 'ulogaId',
                      decoration: InputDecoration(
                        labelText: "Uloga *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: "Odabir uloge je obavezan",
                      ),
                      items: (uloge ?? [])
                          .where(
                            (k) => k.ulogaId != null && k.nazivUloge != 'Admin',
                          )
                          .map<DropdownMenuItem<int>>(
                            (k) => DropdownMenuItem<int>(
                              value: k.ulogaId!,
                              child: Text(k.nazivUloge ?? 'Nepoznato'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedUlogaId = val ?? 0;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Username
                    FormBuilderTextField(
                      name: "korisnickoIme",
                      decoration: InputDecoration(
                        labelText: "Korisničko ime *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: "Korisničko ime je obavezno",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    FormBuilderTextField(
                      name: "telefon",
                      decoration: InputDecoration(
                        labelText: "Broj telefona *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Broj telefona je obavezan",
                        ),
                        FormBuilderValidators.match(
                          RegExp(r'^\+?\d{6,15}$'),
                          errorText: "Unesite validan broj telefona",
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    FormBuilderTextField(
                      name: "lozinka",
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Lozinka *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Lozinka je obavezna",
                        ),
                        FormBuilderValidators.minLength(
                          6,
                          errorText: "Minimalno 6 karaktera",
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    FormBuilderTextField(
                      name: "lozinkaPotvrda",
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: "Potvrdi lozinku *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        final password =
                            _formKey.currentState?.fields['lozinka']?.value;
                        if (value == null || value.isEmpty) {
                          return "Potvrda lozinke je obavezna";
                        }
                        if (value.length < 6) {
                          return "Minimalno 6 karaktera";
                        }
                        if (value != password) {
                          return "Lozinke se ne poklapaju";
                        }
                        return null;
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
                          "Registruj se",
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
