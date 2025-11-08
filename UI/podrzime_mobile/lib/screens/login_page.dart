import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:podrzime_mobile/modals/korisnik.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';
import 'package:podrzime_mobile/modals/uloga.dart';
import 'package:podrzime_mobile/providers/donacije_provider.dart';
import 'package:podrzime_mobile/providers/kategorija_provider.dart';
import 'package:podrzime_mobile/providers/korisnik_provider.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/providers/uloga_provider.dart';
import 'package:podrzime_mobile/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_mobile/screens/pocetna.dart';
import 'package:podrzime_mobile/utils/authorization.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/utils/uloga.dart';
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
  int? ulogaTakmicarId;
  int? ulogaDonorId;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ulogaProvider = context.read<UlogaProvider>();
    loadUloge();
  }

  Future<void> loadUloge() async {
    var uloge = await _ulogaProvider.get();
    for (var u in uloge) {
      if (u.nazivUloge == 'Donor') {
        ulogaDonorId = u.ulogaId;
      } else if (u.nazivUloge == 'Takmicar') {
        ulogaTakmicarId = u.ulogaId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _korisnikProvider = context.read<KorisnikProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/podrziMe_logo.png',
                    height: size.height * 0.18,
                  ),
                ),
                const SizedBox(height: 40),

                // Welcome Text
                const Text(
                  "Dobrodošli u PodržiMe 👋",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Prijavite se kako biste nastavili",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // Form
                TextField(
                  controller: _username,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Korisničko ime",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Lozinka",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final username = _username.text.trim();
                            final password = _password.text.trim();

                            if (username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Molimo unesite korisničko ime i lozinku.",
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);
                            Authorization.username = username;
                            Authorization.password = password;

                            try {
                              List<Korisnik> data = await _korisnikProvider
                                  .get();

                              Korisnik? korisnik = data
                                  .cast<Korisnik?>()
                                  .firstWhere(
                                    (x) => x?.korisnickoIme == username,
                                    orElse: () => null,
                                  );

                              print('Kooorisniiik ${korisnik?.ulogaId}');
                              Logiranikorisnik.korisnik = korisnik;

                              if (korisnik?.ulogaId == ulogaDonorId) {
                                UlogaLogiranogKorisnika.isDonor = true;
                                UlogaLogiranogKorisnika.isTakmicar = false;
                              }
                              if (korisnik?.ulogaId == ulogaTakmicarId) {
                                UlogaLogiranogKorisnika.isTakmicar = true;
                                UlogaLogiranogKorisnika.isDonor = false;
                              }
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
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Greška: $e"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Prijavi se",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Zaboravili ste lozinku?",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
