import 'package:podrzime_admin/main.dart';
import 'package:podrzime_admin/screens/add_takmicar.dart';
import 'package:podrzime_admin/screens/all_takmicars.dart';
import 'package:podrzime_admin/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:podrzime_admin/screens/login_page.dart';
import 'package:podrzime_admin/screens/pocetna.dart';
import 'package:podrzime_admin/screens/pregled_donacija.dart';
import 'package:podrzime_admin/screens/pregled_donora.dart';
import 'package:podrzime_admin/screens/pregled_uspjesnih_prica.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;
  bool showBackButton;

  MasterScreenWidget({
    this.child,
    this.title,
    this.title_widget,
    this.showBackButton = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        title: widget.title_widget ?? Text(widget.title ?? ""),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ListTile(
              title: Text('Pocetna stranica'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PocetnaStranica()),
                );
              },
            ),
            ListTile(
              title: Text('Zahtjev za kandidatima'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePageScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Pregled donora'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PregledDonora()),
                );
              },
            ),
            ListTile(
              title: Text('Pregled uspjesnih prica'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PregledUspjesnihPrica(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Pregled svih kandidata'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PregledSvihTakmicara(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Pregled svih donacija'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PregledDonacijaScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
