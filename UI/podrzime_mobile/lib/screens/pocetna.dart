import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/searchResults.dart';
import 'package:podrzime_mobile/modals/uspjesnaPrica.dart';
import 'package:podrzime_mobile/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_mobile/screens/dodaj_takmicara.dart';
import 'package:podrzime_mobile/screens/login_page.dart';
import 'package:podrzime_mobile/screens/pregled_uspjesnih_prica.dart';
import 'package:podrzime_mobile/utils/authorization.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';

class PocetnaStranica extends StatefulWidget {
  const PocetnaStranica({super.key});

  @override
  State<PocetnaStranica> createState() => _PocetnaStranicaState();
}

class _PocetnaStranicaState extends State<PocetnaStranica> {
  late UspjesnaPricaProvider _uspjesnaPricaProvider;
  List<UspjesnaPrica> filteredListOfUspjesnaPrica = [];
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uspjesnaPricaProvider = context.read<UspjesnaPricaProvider>();
    setUspjesnaPrica();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(title: 'Home', child: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🌄 Header with rotated image and overlay
          SizedBox(
            height: size.height * 0.45,
            child: Stack(
              children: [
                // Background image (rotated + transparent)
                Positioned.fill(
                  child: Transform.rotate(
                    angle: -0.1,
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/images/teens_cover.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Gradient overlay for better contrast
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                // Text & CTA button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Želiš li biti dio\nboljeg sutra naše omladine?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black54,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            elevation: 6,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Navigate somewhere
                          },
                          child: const Text(
                            "Uplati odmah",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✨ Dashed line separator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: DashedLineHorizontalPainter(color: Colors.green),
            ),
          ),

          // 🌱 Content section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pogledaj uspjesne priče!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 240, // slightly taller to fit "See More"
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filteredListOfUspjesnaPrica.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = filteredListOfUspjesnaPrica[index];
                      final screenWidth = MediaQuery.of(context).size.width;
                      final cardWidth = screenWidth * 0.8;

                      return SizedBox(
                        width: cardWidth,
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              // Background image
                              Positioned.fill(
                                child:
                                    (item.slika != null &&
                                        item.slika!.isNotEmpty)
                                    ? Image.memory(
                                        base64Decode(
                                          item.slika!.startsWith('data:image')
                                              ? item.slika!.split(',').last
                                              : item.slika!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),

                              // Dark gradient overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Text overlay
                              Positioned(
                                left: 16,
                                right: 16,
                                bottom: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.naslovPrice,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.prica.length > 80
                                          ? '${item.prica.substring(0, 80)}...'
                                          : item.prica,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    // See More button with icon
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white24,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Navigate to detail page or show full story
                                          print(
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PregledUspjesnihPrica(item),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                        ),
                                        label: const Text(
                                          "See More",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(
                          255,
                          240,
                          245,
                          240,
                        ), // very light greenish tint
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: WaveSeparatorPainter(
                      color: Colors.greenAccent.shade100,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "I ti možeš postati dio naših uspješnih priča!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Ako si talentovan, vrijedan i imaš cilj – bilo da se baviš sportom, umjetnošću ili edukacijom – "
                        "prijavi se i ostvari podršku koja će ti pomoći da ispuniš svoj san. "
                        "Zajedno gradimo bolje sutra!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (Authorization.username != null &&
                              Authorization.password != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddTakmicar(),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.person_add_alt_1),
                        label: const Text(
                          "Prijavi se kao kandidat",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setUspjesnaPrica() async {
    try {
      var data = await _uspjesnaPricaProvider.get();
      print(data);
      setState(() {
        filteredListOfUspjesnaPrica = data ?? [];
        isLoading = false; // hide loader
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}

/// 🎨 Horizontal dashed line painter (styled)
class DashedLineHorizontalPainter extends CustomPainter {
  final Color color;

  DashedLineHorizontalPainter({this.color = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WaveSeparatorPainter extends CustomPainter {
  final Color color;

  WaveSeparatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.6,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
