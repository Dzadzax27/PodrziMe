import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:podrzime_mobile/modals/obavijest.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/providers/obavijest_provider.dart';
import 'package:podrzime_mobile/providers/takmicar_provider.dart';
import 'package:podrzime_mobile/providers/takmicarProfil_provider.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';

class ObavijestiPage extends StatefulWidget {
  const ObavijestiPage({super.key});

  @override
  State<ObavijestiPage> createState() => _ObavijestiPageState();
}

class _ObavijestiPageState extends State<ObavijestiPage> {
  late ObavijestProvider _obavijestProvider;
  late TakmicarProfilProvider _takmicarProfilProvider;
  late TakmicarProvider _takmicarProvider;

  List<Obavijest> obavijesti = [];
  List<Takmicar>? takmicari;

  bool isLoading = true;
  final Set<int> expandedObavijesti = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _obavijestProvider = context.read<ObavijestProvider>();
    _takmicarProfilProvider = context.read<TakmicarProfilProvider>();
    _takmicarProvider = context.read<TakmicarProvider>();
    loadObavijesti();
  }

  Future<void> loadObavijesti() async {
    setState(() => isLoading = true);

    final profilList = await _takmicarProfilProvider.get();
    final korisnikProfil = profilList
        .where((x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId)
        .toList();

    final aktivniProfil = korisnikProfil.isNotEmpty
        ? korisnikProfil.first
        : null;

    takmicari = await _takmicarProvider.get();
    takmicari = (takmicari ?? [])
        .where((x) => x.takmicarProfilId == aktivniProfil?.takmicarProfilId)
        .toList();

    final sveObavijesti = await _obavijestProvider.get();
    final korisnickeObavijesti = <Obavijest>[];

    for (final o in sveObavijesti) {
      for (final t in takmicari ?? []) {
        if (o.kandidatId != null && o.kandidatId == t.kandidatId) {
          korisnickeObavijesti.add(o);
          break;
        }
      }
    }

    setState(() {
      obavijesti = korisnickeObavijesti;
      isLoading = false;
    });
  }

  Future<void> _markAsSeen(Obavijest o) async {
    if (o.id == null || o.hasBeenSeen == true) return;

    final updated = Obavijest(
      id: o.id,
      sadrzaj: o.sadrzaj,
      datumKreiranja: o.datumKreiranja,
      kandidatId: o.kandidatId,
      hasBeenSeen: true,
    );

    await _obavijestProvider.update(o.id!, updated);

    setState(() {
      o.hasBeenSeen = true;
    });
  }

  IconData _getIcon(String text) {
    final t = text.toLowerCase();
    if (t.contains('donacija')) return Icons.volunteer_activism;
    if (t.contains('poruka')) return Icons.message;
    if (t.contains('poziv')) return Icons.call;
    return Icons.notifications;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moje obavijesti",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : obavijesti.isEmpty
          ? const Center(child: Text("Nema obavijesti"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: obavijesti.map((o) {
                  final isRead = o.hasBeenSeen == true;
                  final isExpanded = expandedObavijesti.contains(o.id);
                  final icon = _getIcon(o.sadrzaj ?? '');

                  return GestureDetector(
                    onTap: () async {
                      await _markAsSeen(o);

                      setState(() {
                        isExpanded
                            ? expandedObavijesti.remove(o.id)
                            : expandedObavijesti.add(o.id!);
                      });
                    },
                    child: Card(
                      elevation: isRead ? 2 : 6,
                      color: isRead ? Colors.white : Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: Colors.green, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          "Nova obavijest",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Text(
                                            "Novo",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    o.sadrzaj ?? '',
                                    maxLines: isExpanded ? null : 1,
                                    overflow: isExpanded
                                        ? null
                                        : TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isRead
                                          ? FontWeight.normal
                                          : FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    o.datumKreiranja != null
                                        ? DateFormat(
                                            'dd.MM.yyyy',
                                          ).format(o.datumKreiranja!)
                                        : '-',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
