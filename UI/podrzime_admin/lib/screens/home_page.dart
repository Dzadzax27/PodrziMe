import 'package:flutter/material.dart';
import 'package:podrzime_admin/widgets/master_screen.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lista proizvoda placeholder"),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Nazad"),
          ),
        ],
      ),
    );
  }
}
