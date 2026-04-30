import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proconnectnb/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../models/aine.dart';
import '../../widgets/tr_text.dart';
import '../../screens/aine/add_aine_screen.dart';
import '../../provider/aine_provider.dart';
import '../partage/partageScreen.dart';

class AineDetailScreen extends StatelessWidget {
  final Aine aine;

  const AineDetailScreen({super.key, required this.aine});

  // --- Dialogue de confirmation de suppression ---
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const TrText("Confirmation"),
          content: const TrText("Voulez-vous vraiment supprimer cet aîné ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const TrText("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                final provider = Provider.of<AineProvider>(
                  context,
                  listen: false,
                );
                final auth = Provider.of<AuthProvider>(context, listen: false);

                Navigator.pop(dialogContext); // Ferme le dialogue

                final success = await provider.deleteAine(aine.id, auth);
                if (success && context.mounted) {
                  Navigator.pop(context); // Retourne à la liste des aînés
                }
              },
              child: const TrText(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TrText("Fiche de l'aîné"),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddAineScreen(aine: aine)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- En-tête Profil ---
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF4A3AFF),
              child: Icon(Icons.elderly, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Text(
              "${aine.prenom} ${aine.nom}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // --- Informations Générales ---
            _infoTile(
              Icons.cake,
              "Né(e) le",
              DateFormat('dd MMMM yyyy').format(aine.dateNaissance),
            ),
            _infoTile(Icons.phone, "Téléphone", aine.telephone),
            _infoTile(Icons.email, "Email", aine.email),
            if (aine.adresse != null)
              _infoTile(
                Icons.location_on,
                "Adresse",
                "${aine.adresse!.rue}, ${aine.adresse!.ville}",
              ),

            const Divider(height: 40),

            // --- Informations Médicales ---
            const TrText(
              "Informations Médicales",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _infoTile(Icons.person_search, "Médecin", aine.docteur),
            _infoTile(
              Icons.phone_android,
              "Contact Médecin",
              aine.numeroDocteur,
            ),

            const SizedBox(height: 40),

            // --- SECTION ACTIONS ---

            // Bouton Partager (Action principale - Elevated)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share, color: Colors.white),
                label: const TrText(
                  "PARTAGER MON SUIVI",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A3AFF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Utilisation de 'initialData' pour correspondre au nouveau constructeur
                    builder: (_) => PartageScreen(initialData: aine),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Bouton Supprimer (Action secondaire - Outlined)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const TrText(
                  "SUPPRIMER L'AÎNÉ",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
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
        value.isEmpty ? "-" : value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
