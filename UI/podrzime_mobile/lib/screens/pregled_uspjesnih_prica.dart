import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:podrzime_mobile/modals/komentar.dart';
import 'package:podrzime_mobile/modals/uspjesnaPrica.dart';
import 'package:podrzime_mobile/providers/komentar_provider.dart';
import 'package:podrzime_mobile/providers/uspjesnaPrica_provider.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';
import 'package:provider/provider.dart';

class PregledUspjesnihPrica extends StatefulWidget {
  final UspjesnaPrica uspjesnaPrica;
  final Komentar? komentar;
  const PregledUspjesnihPrica(this.uspjesnaPrica, {super.key, this.komentar});

  @override
  State<PregledUspjesnihPrica> createState() => _PregledUspjesnihPricaState();
}

class _PregledUspjesnihPricaState extends State<PregledUspjesnihPrica> {
  late UspjesnaPricaProvider _uspjesnaPricaProvider;
  late KomentarProvider _komentarProvider;
  List<Komentar>? komentari;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initialValue = {'komentar1': widget?.komentar?.komentar1 ?? ''};
    _uspjesnaPricaProvider = UspjesnaPricaProvider();
    _komentarProvider = context.read<KomentarProvider>();
    loadKomentare();
  }

  Future<void> _sacuvajKomentar() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);

      if (Logiranikorisnik.korisnik != null) {
        formData['korisnikId'] = Logiranikorisnik.korisnik?.korisnikId;
      }
      formData['uspjesnaPricaId'] = widget.uspjesnaPrica.uspjesnaPricaId;

      await _komentarProvider.insert(formData);

      _formKey.currentState?.reset();
      loadKomentare();
    }
  }

  Future<void> loadKomentare() async {
    var filter = {'isUspjesnaPricaIncluded': false, 'isKorisnikIncluded': true};
    final result = await _komentarProvider.get(filter);

    print('Result ${result}');

    setState(() {
      komentari = result
          .where(
            (x) => x.uspjesnaPricaId == widget.uspjesnaPrica?.uspjesnaPricaId,
          )
          .toList();
      print('Komentari $komentari');
    });
  }

  @override
  Widget build(BuildContext context) {
    final uspjesnaPrica = widget.uspjesnaPrica;

    return MasterScreenWidget(
      title: "Pregled uspješnih priča",
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
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
                                    uspjesnaPrica.slika!.startsWith(
                                          'data:image',
                                        )
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
              // Komentari naslov
              const SizedBox(height: 20),
              // Title and form wrapper
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Komentari",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Existing comments
                    if (komentari == null)
                      const Center(child: CircularProgressIndicator())
                    else if (komentari!.isEmpty)
                      const Text(
                        "Nema komentara.",
                        style: TextStyle(color: Colors.black54),
                      )
                    else
                      Column(
                        children: komentari!.map((k) {
                          final autor = k.korisnikId == null
                              ? "Anonymous"
                              : "${k.korisnik?.korisnickoIme}";
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  autor,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  k.komentar1 ?? "",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Icon(
                          Icons.mode_comment_outlined,
                          color: Colors.black87,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Komentariši",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dodaj komentar form
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Input box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: FormBuilderTextField(
                              name: 'komentar1',
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText: "Napiši komentar...",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Komentar ne može biti prazan";
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Send button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _sacuvajKomentar(),
                              icon: const Icon(Icons.send, size: 18),
                              label: const Text(
                                "Komentariši",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
