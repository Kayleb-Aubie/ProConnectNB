import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/aine_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/partage_provider.dart';
import 'add_aine_screen.dart';
import 'aine_detail_screen.dart';
import '../../widgets/tr_text.dart';

class ListAineScreen extends StatelessWidget {
  const ListAineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aineProvider = Provider.of<AineProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final partageProv = Provider.of<PartageProvider>(context);
    final currentId = auth.currentUserLocalId ?? 0;
    // FILTRE : On récupère les IDs des aînés liés à ce proche
    final mesAinesSuivisIds = partageProv
        .getPartagesParProche(currentId) // Utilise l'ID sécurisé
        .map((p) => p.aineId)
        .toList();

    // On filtre la liste globale pour n'afficher que les liens valides
    final ainesAffichables = aineProvider.aines.where((aine) {
      return mesAinesSuivisIds.contains(aine.id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const TrText("Mes Aînés"),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body: aineProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ainesAffichables.isEmpty
          ? const Center(
              child: TrText("Aucun aîné sous votre suivi actuellement"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: ainesAffichables.length,
              itemBuilder: (context, index) {
                final aine = ainesAffichables[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF4A3AFF),
                      child: Text(
                        aine.prenom[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      "${aine.prenom} ${aine.nom}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(aine.telephone),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AineDetailScreen(aine: aine),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A3AFF),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAineScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
