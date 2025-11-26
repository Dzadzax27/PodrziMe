import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';
import 'package:podrzime_mobile/providers/donacije_provider.dart';
import 'package:podrzime_mobile/providers/donor_provider.dart';
import 'package:podrzime_mobile/providers/kategorija_provider.dart';
import 'package:podrzime_mobile/providers/komentar_provider.dart';
import 'package:podrzime_mobile/providers/korisnik_provider.dart';
import 'package:podrzime_mobile/providers/obavijest_provider.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/providers/uloga_provider.dart';
import 'package:podrzime_mobile/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_mobile/screens/login_page.dart';
import 'package:podrzime_mobile/screens/pocetna.dart';
import 'package:podrzime_mobile/utils/authorization.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DonacijaProvider()),
        ChangeNotifierProvider(create: (_) => UspjesnaPricaProvider()),
        ChangeNotifierProvider(create: (_) => TakmicarProvider()),
        ChangeNotifierProvider(create: (_) => KategorijaProvider()),
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
        ChangeNotifierProvider(create: (_) => UlogaProvider()),
        ChangeNotifierProvider(create: (_) => DonorProvider()),
        ChangeNotifierProvider(create: (_) => TakmicarProfilProvider()),
        ChangeNotifierProvider(create: (_) => KomentarProvider()),
        ChangeNotifierProvider(create: (_) => ObavijestProvider()),
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
      debugShowCheckedModeBanner: false,
      title: 'PodržiMe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const PocetnaStranica(),
    );
  }
}
