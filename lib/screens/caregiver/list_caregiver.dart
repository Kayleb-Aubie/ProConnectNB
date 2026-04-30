import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/caregiver_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/partage_provider.dart';
import 'add_caregiver_screen.dart';
import 'caregiver_detail_screen.dart';
import '../../widgets/tr_text.dart';

class ListCaregiverScreen extends StatefulWidget {
  const ListCaregiverScreen({super.key});

  @override
  State<ListCaregiverScreen> createState() => _ListCaregiverScreenState();
}

class _ListCaregiverScreenState extends State<ListCaregiverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<CaregiverProvider>(
        context,
        listen: false,
      ).fetchCaregivers(auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final caregiverProvider = context.watch<CaregiverProvider>();
    final auth = context.read<AuthProvider>();
    final partageProv = context.watch<PartageProvider>();

    // FILTRE : On récupère les IDs des proches autorisés par cet aîné
    final currentId = auth.currentUserLocalId ?? 0;
    final mesProchesAutorisesIds = partageProv
        .getPartagesParAine(currentId) // Utilise l'ID sécurisé
        .map((p) => p.procheAidantId)
        .toList();

    final prochesAffichables = caregiverProvider.caregivers.where((proche) {
      return mesProchesAutorisesIds.contains(proche.id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const TrText("Mes Proches Aidants"),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body: caregiverProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prochesAffichables.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () => caregiverProvider.fetchCaregivers(auth),
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: prochesAffichables.length,
                itemBuilder: (ctx, index) {
                  final caregiver = prochesAffichables[index];

                  return Dismissible(
                    key: ValueKey(caregiver.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const TrText("Confirmation"),
                          content: const TrText("Supprimer ce proche aidant ?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const TrText("Annuler"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const TrText("Supprimer"),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (_) async {
                      await caregiverProvider.deleteCaregiver(
                        caregiver.id,
                        auth,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: TrText("Proche supprimé"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF4A3AFF),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          "${caregiver.prenom} ${caregiver.nom}",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Text(caregiver.telephone),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    caregiver.email,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CaregiverDetailScreen(caregiver: caregiver),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A3AFF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCaregiverScreen()),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 10),
          const TrText(
            "Aucun aidant autorisé à voir votre suivi",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              context.read<CaregiverProvider>().fetchCaregivers(auth);
            },
            child: const TrText("Actualiser"),
          ),
        ],
      ),
    );
  }
}
