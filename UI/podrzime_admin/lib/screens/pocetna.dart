import 'package:flutter/material.dart';
import 'package:podrzime_admin/screens/all_takmicars.dart';
import 'package:podrzime_admin/screens/dodaj_uspjesnu_pricu.dart';
import 'package:podrzime_admin/screens/home_page.dart';
import 'package:podrzime_admin/screens/pregled_donacija.dart';
import 'package:podrzime_admin/screens/pregled_donora.dart';
import 'package:podrzime_admin/screens/pregled_uspjesnih_prica.dart';
import 'package:podrzime_admin/utils/util.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';

class KandidatiCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconBackground;

  const KandidatiCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(this.icon, color: Colors.black, size: 32),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors
                          .click, // 👈 changes cursor to pointer
                      child: Row(
                        children: [
                          Text(
                            "Pogledaj",
                            style: TextStyle(
                              color: Color.fromARGB(255, 191, 69, 60),
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Color.fromARGB(255, 191, 69, 60),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PocetnaStranica extends StatefulWidget {
  const PocetnaStranica({super.key});

  @override
  State<PocetnaStranica> createState() => _PocetnaStranica();
}

class _PocetnaStranica extends State<PocetnaStranica> {
  String username = Authorization.username ?? '';
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(title: "", child: _buildForm());
  }

  Widget _buildForm() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dobrodošlica
            Text(
              'Dobrodošao, $username!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Grid sa karticama
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 40, // horizontal spacing between cards
                  runSpacing: 40, // vertical spacing between cards
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: 300, // card width
                      height: 130, // card height
                      child: KandidatiCard(
                        title: "Zahtjev za kandidatima",
                        icon: Icons.person_add,
                        iconBackground: const Color(0xFFD0E8F2),
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomePageScreen(),
                            ),
                          ),
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300, // card width
                      height: 130, // card height
                      child: KandidatiCard(
                        title: "Uspjesne price",
                        icon: Icons.emoji_events,
                        iconBackground: const Color(0xFFF8C8DC),
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PregledUspjesnihPrica(),
                            ),
                          ),
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300, // card width
                      height: 130, // card height
                      child: KandidatiCard(
                        title: "Donori",
                        icon: Icons.volunteer_activism,
                        iconBackground: const Color(0xFFFFF3B0),
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PregledDonora(),
                            ),
                          ),
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300, // card width
                      height: 130, // card height
                      child: KandidatiCard(
                        title: "Svi kandidati",
                        icon: Icons.people,
                        iconBackground: const Color.fromARGB(
                          255,
                          130,
                          209,
                          200,
                        ),
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PregledSvihTakmicara(),
                            ),
                          ),
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 130,
                      child: KandidatiCard(
                        title: "Sve donacije",
                        icon: Icons.payments,
                        iconBackground: const Color(0xFFD1F2EB), // soft green
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PregledDonacijaScreen(),
                            ),
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
