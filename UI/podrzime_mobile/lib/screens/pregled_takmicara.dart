import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:podrzime_mobile/modals/donacija.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/providers/donacije_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/screens/login_page.dart';
import 'package:podrzime_mobile/screens/paypal_screen.dart';
import 'package:podrzime_mobile/utils/authorization.dart';
import 'package:podrzime_mobile/utils/uloga.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';

class PregledTakmicara extends StatefulWidget {
  final dynamic takmicar;
  const PregledTakmicara(this.takmicar, {super.key});

  @override
  State<PregledTakmicara> createState() => _PregledTakmicaraState();
}

class _PregledTakmicaraState extends State<PregledTakmicara> {
  late TakmicarProvider _takmicarProvider;
  late DonacijaProvider _donacijaProvider;
  List<Takmicar>? _preporuceniTakmicari;
  int ukupnoDonacija = 0;

  @override
  void initState() {
    super.initState();
    _takmicarProvider = TakmicarProvider();
    _donacijaProvider = DonacijaProvider();
    recommendation();
    print('Uloga ${UlogaLogiranogKorisnika.isDonor}');
    izracunajUkupanIznosDonacije();
  }

  Future<void> izracunajUkupanIznosDonacije() async {
    var donacije = await _donacijaProvider.get();
    donacije = donacije
        .where((x) => x.kandidatId == widget.takmicar.kandidatId)
        .toList();

    int suma = 0;
    for (var d in donacije) {
      suma += d.iznosDonacije ?? 0;
    }

    setState(() {
      ukupnoDonacija = suma;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Zahtjev za takmičarom",
      child: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    var takmicar = widget.takmicar;
    print('Zeljena donacija ${widget.takmicar.zeljenaDonacija}');
    double goal = widget.takmicar.zeljenaDonacija?.toDouble() ?? 0;
    double collected = ukupnoDonacija.toDouble();
    double remaining = (goal - collected).clamp(0, goal);
    double progress = goal > 0 ? collected / goal : 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16), // mobilni-friendly padding
      child: Column(
        children: [
          Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // smanjen padding za mobilni
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🧍 Slika i osnovni info
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
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${takmicar.ime} ${takmicar.prezime}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 40, 40, 40),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Kategorija: ${takmicar.kategorija?.nazivKategorije ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 191, 69, 60),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Datum rođenja: ${takmicar.datumRodjenja != null ? DateFormat('dd.MM.yyyy').format(takmicar.datumRodjenja) : 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // O meni
                    const Text(
                      "O meni:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      takmicar.omeni ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Link
                    const Text(
                      "Link:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      takmicar.link ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Uspjesi
                    const Text(
                      "Uspjesi:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      takmicar.uspjesi ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Kontakt
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 191, 69, 60),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          takmicar.email ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 191, 69, 60),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          takmicar.brojTelefona?.toString() ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,

                      child: UlogaLogiranogKorisnika.isDonor == true
                          ? ElevatedButton.icon(
                              onPressed: () async {
                                if (Authorization.username == null ||
                                    Authorization.password == null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                  return;
                                }

                                // Show PayPal modal
                                final result = await showDialog<Map<String, dynamic>>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    final _formKey = GlobalKey<FormState>();
                                    final TextEditingController
                                    _amountController = TextEditingController();
                                    final TextEditingController
                                    _descriptionController =
                                        TextEditingController();

                                    return AlertDialog(
                                      title: const Text('Unesite iznos i opis'),
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _amountController,
                                              keyboardType:
                                                  TextInputType.numberWithOptions(
                                                    decimal: true,
                                                  ),
                                              decoration: const InputDecoration(
                                                labelText: 'Iznos (USD)',
                                                prefixIcon: Icon(
                                                  Icons.attach_money,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty)
                                                  return 'Unesite iznos';
                                                final amount = double.tryParse(
                                                  value,
                                                );
                                                if (amount == null ||
                                                    amount <= 0)
                                                  return 'Unesite validan iznos';
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormField(
                                              controller:
                                                  _descriptionController,
                                              decoration: const InputDecoration(
                                                labelText: 'Opis',
                                                prefixIcon: Icon(
                                                  Icons.description,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty)
                                                  return 'Unesite opis';
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(null),
                                          child: const Text('Otkaži'),
                                        ),

                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              Navigator.of(context).pop({
                                                'amount': double.parse(
                                                  _amountController.text,
                                                ),
                                                'description':
                                                    _descriptionController.text,
                                              });
                                            }
                                          },
                                          child: const Text('Uplati'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (result != null) {
                                  final amount = result['amount'] as double;
                                  final description =
                                      result['description'] as String;

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PayPalPaymentScreen(
                                        amount: amount,
                                        description: description,
                                        takmicar: takmicar,
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.attach_money),
                              label: const Text("Uplati odmah"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    UlogaLogiranogKorisnika.isTakmicar == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),

                              // PROGRESS BAR
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        "Goal",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        "${goal.toStringAsFixed(0)} BAM",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        "Prikupljeno",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        "${collected.toStringAsFixed(0)} BAM",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        "Ostalo",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        "${remaining.toStringAsFixed(0)} BAM",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
          // ⭐ PREPORUČENI TAKMIČARI
          if (_preporuceniTakmicari != null &&
              _preporuceniTakmicari!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Preporučeni takmičari",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 40, 40, 40),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _preporuceniTakmicari!.length,
                    itemBuilder: (context, index) {
                      var t = _preporuceniTakmicari![index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PregledTakmicara(t),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 12),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // SLika
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        (t.slika != null && t.slika!.isNotEmpty)
                                        ? Image.memory(
                                            base64Decode(
                                              t.slika!.startsWith("data:image")
                                                  ? t.slika!.split(",").last
                                                  : t.slika!,
                                            ),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.person,
                                              size: 40,
                                            ),
                                          ),
                                  ),

                                  const SizedBox(height: 8),
                                  Text(
                                    "${t.ime} ${t.prezime}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    t.kategorija?.nazivKategorije ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> recommendation() async {
    var result = await _takmicarProvider.getRecommendations(
      widget.takmicar.kandidatId,
    );

    setState(() {
      _preporuceniTakmicari = result;
    });

    print('Preporuceni $_preporuceniTakmicari');
  }
}
