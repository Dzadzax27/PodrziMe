import 'package:podrzime_admin/main.dart';
import 'package:podrzime_admin/screens/add_takmicar.dart';
import 'package:podrzime_admin/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:podrzime_admin/screens/login_page.dart';
import 'package:podrzime_admin/screens/pocetna.dart';
import 'package:podrzime_admin/screens/pregled_uspjesnih_prica.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({this.child, this.title, this.title_widget, Key? key})
    : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.title_widget ?? Text(widget.title ?? "")),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Back'),
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
              title: Text('Naslovna strana'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePageScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Dodaj Takmicara'),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AddTakmicar()));
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
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
