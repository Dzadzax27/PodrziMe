import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_admin/providers/takmicar_provider.dart';
import 'package:podrzime_admin/providers/donacija_provider.dart';
import 'package:podrzime_admin/screens/home_page.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class PregledTakmicara extends StatefulWidget {
  final dynamic takmicar;
  const PregledTakmicara(this.takmicar, {super.key});

  @override
  State<PregledTakmicara> createState() => _PregledTakmicaraState();
}

class _PregledTakmicaraState extends State<PregledTakmicara> {
  late TakmicarProvider _takmicarProvider;
  late DonacijaProvider _donacijaProvider;

  int ukupnoDonacija = 0;

  @override
  void initState() {
    super.initState();
    _takmicarProvider = TakmicarProvider();
    _donacijaProvider = DonacijaProvider();
    _izracunajUkupanIznosDonacije();
  }

  Future<void> _izracunajUkupanIznosDonacije() async {
    var donacije = await _donacijaProvider.get(); // Dobavi sve donacije
    final donacijeResult = await _donacijaProvider.get();
    final filteredDonacije =
        donacijeResult.result
            ?.where((d) => d.kandidatId == widget.takmicar.kandidatId)
            .toList() ??
        [];

    int suma = 0;
    for (var d in filteredDonacije) {
      suma += d.iznosDonacije ?? 0;
    }

    setState(() {
      ukupnoDonacija = suma;
    });

    setState(() {
      ukupnoDonacija = suma;
    });
  }

  @override
  Widget build(BuildContext context) {
    var takmicar = widget.takmicar;

    double goal = (takmicar.zeljenaDonacija ?? 0).toDouble();
    double collected = ukupnoDonacija.toDouble();
    double remaining = (goal - collected).clamp(0, goal);
    double progress = goal > 0 ? collected / goal : 0;

    return MasterScreenWidget(
      title: "Zahtjev za takmičarom",
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 200.0,
                vertical: 40.0,
              ),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼 Slika i osnovni podaci
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                (takmicar.slika != null &&
                                    takmicar.slika!.isNotEmpty)
                                ? Image.memory(
                                    base64Decode(
                                      takmicar.slika!.startsWith('data:image')
                                          ? takmicar.slika!.split(',').last
                                          : takmicar.slika!,
                                    ),
                                    width: 180,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 180,
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${takmicar.ime} ${takmicar.prezime}",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 40, 40, 40),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 3,
                                  width: 80,
                                  color: const Color.fromARGB(255, 191, 69, 60),
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    const Text(
                                      "Kategorija:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      takmicar.kategorija?.nazivKategorije ??
                                          "N/A",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 191, 69, 60),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Text(
                                      "Datum Rodjenja :",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      takmicar.datumRodjenja != null
                                          ? DateFormat(
                                              'dd.MM.yyyy',
                                            ).format(takmicar.datumRodjenja)
                                          : "N/A",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "O meni:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        takmicar.omeni ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            "Link:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            takmicar.link ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Uspjesi:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        takmicar.uspjesi ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 191, 69, 60),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            takmicar.email ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 191, 69, 60),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            takmicar.brojTelefona?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (takmicar.odobren == null) ...[
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  takmicar.odobren = true;
                                  await _takmicarProvider.update(
                                    takmicar.kandidatId!,
                                    takmicar.toJson(),
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => HomePageScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Prihvati',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 20, 125, 14),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              TextButton(
                                onPressed: () {
                                  takmicar.odobren = false;
                                  _takmicarProvider.update(
                                    takmicar.kandidatId!,
                                    takmicar.toJson(),
                                  );
                                },
                                child: const Text(
                                  'Odbij',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (takmicar.odobren == true) ...[
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 12,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Goal: ${goal.toInt()} BAM",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Prikupljeno: ${collected.toInt()} BAM",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Ostalo: ${remaining.toInt()} BAM",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
