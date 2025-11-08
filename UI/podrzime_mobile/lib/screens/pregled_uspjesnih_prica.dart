import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/uspjesnaPrica.dart';
import 'package:podrzime_mobile/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';

class PregledUspjesnihPrica extends StatefulWidget {
  final UspjesnaPrica uspjesnaPrica;
  const PregledUspjesnihPrica(this.uspjesnaPrica, {super.key});

  @override
  State<PregledUspjesnihPrica> createState() => _PregledUspjesnihPricaState();
}

class _PregledUspjesnihPricaState extends State<PregledUspjesnihPrica> {
  late UspjesnaPricaProvider _uspjesnaPricaProvider;

  @override
  void initState() {
    super.initState();
    _uspjesnaPricaProvider = UspjesnaPricaProvider();
  }

  @override
  Widget build(BuildContext context) {
    final uspjesnaPrica = widget.uspjesnaPrica;

    return MasterScreenWidget(
      title: "Pregled uspješnih priča",
      child: Center(
        child: SizedBox(
          // height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image section (fixed height)
                    SizedBox(
                      height: 250,
                      child:
                          (uspjesnaPrica.slika != null &&
                              uspjesnaPrica.slika!.isNotEmpty)
                          ? Image.memory(
                              base64Decode(
                                uspjesnaPrica.slika!.startsWith('data:image')
                                    ? uspjesnaPrica.slika!.split(',').last
                                    : uspjesnaPrica.slika!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                    ),

                    // Scrollable content section
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height *
                          0.5, // adjust to card height or leave flexible
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              uspjesnaPrica.naslovPrice,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Divider
                            Container(
                              height: 3,
                              width: 60,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(height: 16),

                            // About section
                            const Text(
                              "Uspjesna prica",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              uspjesnaPrica.prica,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Donation info
                            Row(
                              children: [
                                const Text(
                                  "Iznos željene donacije: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  uspjesnaPrica.ukupnaDonacija.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Action button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
