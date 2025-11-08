import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:podrzime_mobile/modals/donor.dart';
import 'package:podrzime_mobile/providers/donor_provider.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:podrzime_mobile/widget/master_screen.dart';

class OMeniDonor extends StatefulWidget {
  const OMeniDonor({super.key});

  @override
  State<OMeniDonor> createState() => _OMeniDonorState();
}

class _OMeniDonorState extends State<OMeniDonor> {
  late DonorProvider _donorProvider;
  Donor? donor;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _donorProvider = context.read<DonorProvider>();
    loadDonor();
  }

  Future<void> loadDonor() async {
    setState(() {
      isLoading = true;
    });

    var donorList = await _donorProvider.get();
    final lista = donorList
        .where(
          (x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId,
        ) // ili neki ID
        .toList();

    setState(() {
      donor = lista.isNotEmpty ? lista.first : null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moj profil",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : donor == null
          ? const Center(child: Text("Donor profil nije pronađen"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ime: ${donor!.ime}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Prezime: ${donor!.prezime}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Zanimanje: ${donor!.zanimanje ?? 'Nije uneseno'}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Ukupno donacija: ${donor!.ukupnoDonacija ?? 0}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Datum rođenja: ${donor!.datumRodjenja != null ? DateFormat('dd.MM.yyyy').format(donor!.datumRodjenja!) : 'Nije unesen'}",
                            style: const TextStyle(fontSize: 18),
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
