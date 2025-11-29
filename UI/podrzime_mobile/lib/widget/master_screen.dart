import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/kategorija.dart';
import 'package:podrzime_mobile/providers/kategorija_provider.dart';
import 'package:podrzime_mobile/screens/dodaj_TakmicarProfil.dart';
import 'package:podrzime_mobile/screens/dodaj_takmicara.dart';
import 'package:podrzime_mobile/screens/login_page.dart';
import 'package:podrzime_mobile/screens/oMeni_donor.dart';
import 'package:podrzime_mobile/screens/oMeni_takmicar.dart';
import 'package:podrzime_mobile/screens/pocetna.dart';
import 'package:podrzime_mobile/screens/pregled_obavijest.dart';
import 'package:podrzime_mobile/screens/pregled_svih_takmicara.dart';
import 'package:podrzime_mobile/screens/pregled_svih_uspjesnihPrica.dart';
import 'package:podrzime_mobile/screens/registracija.dart';
import 'package:podrzime_mobile/utils/authorization.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/utils/uloga.dart';
import 'package:provider/provider.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;

  const MasterScreenWidget({Key? key, this.child, this.title})
    : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget>
    with SingleTickerProviderStateMixin {
  bool _showMenu = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  String? _hoveredItem; // for hover effect

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
      if (_showMenu) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _buildMenuItem(String title) {
    return InkWell(
      onTap: () {
        if (title == 'Pocetna') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => PocetnaStranica()));
        } else if (title == 'Kandidati') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddTakmicar()));
        } else if (title == 'Pregled Kandidata') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PregledSvihTakmicara()),
          );
        } else if (title == 'Dodaj Kandidata') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddTakmicar()));
        } else if (title == 'O meni') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => OMeniTakmicar()));
        } else if (title == 'Logout') {
          Authorization.username = '';
          Authorization.password = '';
          UlogaLogiranogKorisnika.isDonor = false;
          UlogaLogiranogKorisnika.isTakmicar = false;
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (title == 'Pregledaj uspjesne price') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PregledSvihUspjesnihPrica(),
            ),
          );
        } else if (title == 'Pregledaj obavijesti donacija') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => ObavijestiPage()));
        }
      },
      borderRadius: BorderRadius.circular(8),
      onHover: (hovering) {
        setState(() {
          _hoveredItem = hovering ? title : null;
        });
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: _hoveredItem == title
            ? Colors.green.withOpacity(0.1)
            : Colors.transparent,
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        actions: [
          (UlogaLogiranogKorisnika.isDonor == false &&
                      UlogaLogiranogKorisnika?.isTakmicar == false) ||
                  (UlogaLogiranogKorisnika.isDonor == null &&
                      UlogaLogiranogKorisnika?.isTakmicar == null)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),

                  child: MouseRegion(
                    cursor:
                        SystemMouseCursors.click, // 👈 makes cursor a pointer
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        overlayColor: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ).withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        "Prijavi se",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          (UlogaLogiranogKorisnika.isDonor == false &&
                      UlogaLogiranogKorisnika?.isTakmicar == false) ||
                  (UlogaLogiranogKorisnika.isDonor == null &&
                      UlogaLogiranogKorisnika?.isTakmicar == null)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click, // 👈 pointer for hover
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        overlayColor: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ).withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Registracija(),
                          ),
                        );
                      },
                      child: const Text(
                        "Registruj se",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 4),
          IconButton(icon: const Icon(Icons.menu), onPressed: _toggleMenu),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Main page content
                widget.child ?? const SizedBox(),

                // Dropdown overlay (appears over everything)
                if (_showMenu)
                  Positioned(
                    right: 10,
                    top: kToolbarHeight - 60, // adjust dropdown position
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuItem('Pocetna'),
                            const Divider(height: 1),
                            UlogaLogiranogKorisnika.isTakmicar == true
                                ? _buildMenuItem('Dodaj Kandidata')
                                : const SizedBox.shrink(),
                            const Divider(height: 1),
                            UlogaLogiranogKorisnika.isTakmicar == true
                                ? _buildMenuItem(
                                    'Pregledaj obavijesti donacija',
                                  )
                                : const SizedBox.shrink(),
                            const Divider(height: 1),
                            _buildMenuItem('Pregled Kandidata'),
                            const Divider(height: 1),
                            _buildMenuItem('Pregledaj uspjesne price'),
                            const Divider(height: 1),
                            (Authorization.username == null &&
                                        Authorization.password == null) ||
                                    (Authorization.username == '' &&
                                        Authorization.password == '')
                                ? const SizedBox.shrink()
                                : _buildMenuItem('O meni'),
                            const Divider(height: 1),
                            Authorization.username == null &&
                                    Authorization.password == null
                                ? _buildMenuItem('Login')
                                : _buildMenuItem('Logout'),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
