import 'package:flutter/material.dart';
import '../../models/caregiver.dart';
import 'add_caregiver_screen.dart';
import '../../widgets/tr_text.dart';

class CaregiverDetailScreen extends StatelessWidget {
  final Caregiver caregiver;

  const CaregiverDetailScreen({super.key, required this.caregiver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TrText("Détails du Proche"),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddCaregiverScreen(caregiver: caregiver),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF4A3AFF),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _infoTile(
              Icons.person_outline,
              "Nom complet",
              "${caregiver.prenom} ${caregiver.nom}",
            ),
            _infoTile(Icons.phone, "Téléphone", caregiver.telephone),
            _infoTile(Icons.email, "Email", caregiver.email),
            if (caregiver.adresse != null)
              _infoTile(
                Icons.location_on,
                "Adresse",
                "${caregiver.adresse!.rue}, ${caregiver.adresse!.ville}",
              ),

            const SizedBox(height: 30),

            // --- BOUTON DE PARTAGE DU SUIVI ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A3AFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.share),
                label: const TrText("PARTAGER MON SUIVI"),
                onPressed: () {
                  // On navigue vers l'écran de partage en passant le proche actuel
                  Navigator.pushNamed(
                    context,
                    '/partageAine',
                    arguments:
                        caregiver, // Le router extraira cet objet pour initialData
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4A3AFF)),
      title: TrText(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
