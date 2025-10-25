import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:podrzime_admin/models/donor.dart';
import 'package:podrzime_admin/models/search_result.dart';
import 'package:podrzime_admin/providers/donor_provider.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class PregledDonora extends StatefulWidget {
  const PregledDonora({super.key});

  @override
  State<PregledDonora> createState() => _PregledDonoraState();
}

class _PregledDonoraState extends State<PregledDonora> {
  late DonorProvider _donorProvider;
  late SearchResult<Donor> listOfDonors;
  List<Donor> filteredDonors = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _donorProvider = context.read<DonorProvider>();
    _loadDonors();
  }

  Future<void> _loadDonors() async {
    try {
      var data = await _donorProvider.get();
      setState(() {
        listOfDonors = data;
        filteredDonors = data.result ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching donors: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Pregled Donora',
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredDonors.isEmpty) {
      return const Center(
        child: Text(
          'Nema donora za prikaz.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: filteredDonors.length,
        itemBuilder: (context, index) {
          final donor = filteredDonors[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8C8DC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: Colors.black87,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Main Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${donor.ime ?? ''} ${donor.prezime ?? ''}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.work_outline, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              donor.zanimanje ?? 'Nepoznato',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.cake_outlined, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              donor.datumRodjenja != null
                                  ? DateFormat(
                                      'dd.MM.yyyy',
                                    ).format(donor.datumRodjenja!)
                                  : "N/A",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right side – Donation info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Ukupno donacija',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        donor.ukupnoDonacija?.toString() ?? '0',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBF453C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
