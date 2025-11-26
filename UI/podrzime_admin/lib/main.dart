import 'package:flutter/material.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/providers/donor_provider.dart';
import 'package:podrzime_admin/providers/kategorija_provider.dart';
import 'package:podrzime_admin/providers/komentar_provider.dart';
import 'package:podrzime_admin/providers/korisnik_provider.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/providers/uloga_provider.dart';
import 'package:podrzime_admin/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_admin/screens/login_page.dart';
import 'package:podrzime_admin/screens/pocetna.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DonacijaProvider()),
        ChangeNotifierProvider(create: (_) => TakmicarProvider()),
        ChangeNotifierProvider(create: (_) => KategorijaProvider()),
        ChangeNotifierProvider(create: (_) => UspjesnaPricaProvider()),
        ChangeNotifierProvider(create: (_) => DonorProvider()),
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
        ChangeNotifierProvider(create: (_) => UlogaProvider()),
        ChangeNotifierProvider(create: (_) => KomentarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PodržiMe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
