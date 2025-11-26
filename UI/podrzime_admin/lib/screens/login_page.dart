import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/korisnik.dart';
import 'package:podrzime_admin/models/search_result.dart';
import 'package:podrzime_admin/models/uspjesnaPrica.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/providers/donor_provider.dart';
import 'package:podrzime_admin/providers/kategorija_provider.dart';
import 'package:podrzime_admin/providers/korisnik_provider.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/providers/uloga_provider.dart';
import 'package:podrzime_admin/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_admin/screens/home_page.dart';
import 'package:podrzime_admin/screens/pocetna.dart';
import 'package:podrzime_admin/utils/util.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late DonacijaProvider _donacijaProvider;
  late KorisnikProvider _korisnikProvider;
  late UlogaProvider _ulogaProvider;
  int? ulogaAdmin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ulogaProvider = context.read<UlogaProvider>();
    loadUloge();
  }

  Future<void> loadUloge() async {
    var uloge = await _ulogaProvider.get();
    for (var u in uloge.result) {
      if (u.nazivUloge == 'Admin') {
        ulogaAdmin = u.ulogaId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _donacijaProvider = context.read<DonacijaProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Login"), backgroundColor: Colors.green),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/podrziMe_logo.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final username = _username.text.trim();
                    final password = _password.text.trim();

                    Authorization.username = username;
                    Authorization.password = password;

                    try {
                      SearchResult<Korisnik> response = await _korisnikProvider
                          .get();

                      List<Korisnik> data = response.result ?? [];
                      Korisnik? korisnik = data.firstWhereOrNull(
                        (x) => x.korisnickoIme == username,
                      );
                      if (korisnik != null && korisnik.ulogaId == ulogaAdmin) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Uspješna prijava!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }

                        // TODO: Navigate to your home page here
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PocetnaStranica(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Greška"),
                              content: const Text("Kredencijali nisu tačni"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the dialog
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Greška"),
                            content: const Text("Kredencijali nisu tačni"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Close the dialog
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
