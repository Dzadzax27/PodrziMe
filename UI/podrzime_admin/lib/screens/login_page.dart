import 'package:flutter/material.dart';
import 'package:podrzime_admin/models/uspjesnaPrica.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/providers/donor_provider.dart';
import 'package:podrzime_admin/providers/kategorija_provider.dart';
import 'package:podrzime_admin/providers/podrziMe_base_api.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    _donacijaProvider = context.read<DonacijaProvider>();

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

                    var data = await _donacijaProvider.get();
                    // final data = await context.read<ApiProvider>().get(
                    //   "KorisnikController",
                    // );

                    // print("Korisnici: $data");

                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PocetnaStranica(),
                        ),
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
