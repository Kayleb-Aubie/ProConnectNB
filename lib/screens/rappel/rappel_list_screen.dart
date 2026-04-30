import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/rappel.dart';
import '../../provider/rappel_provider.dart';

class RappelListScreen extends StatelessWidget {
  const RappelListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rappels = context.watch<RappelProvider>().rappels;

    final rappelsMedicaments =
        rappels.where((r) => r.medicamentId != null).toList();

    final rappelsRendezVous =
        rappels.where((r) => r.rendezVousMedicalId != null).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: const Text("Mes Rappels"),
          backgroundColor: const Color(0xFF405667),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.medication),
                text: "Médicaments",
              ),
              Tab(
                icon: Icon(Icons.event),
                text: "Rendez-vous",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // MÉDICAMENTS
            rappelsMedicaments.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildSection(
                      context,
                      rappelsMedicaments,
                      true,
                    ),
                  ),
            // RENDEZ-VOUS
            rappelsRendezVous.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildSection(
                      context,
                      rappelsRendezVous,
                      false,
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0074D9),
          foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
          onPressed: () {
            Navigator.pushNamed(context, '/add-rappel');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );

  }

  Widget _buildSection(
    BuildContext context,
    List<Rappel> rappels,
    bool isMedicament,
  ) {
    if (rappels.isEmpty) {
      return const Text(
        "Aucun rappel",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: rappels.map((rappel) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            onTap: () {
              _openEditRappel(context, rappel);
            },
            leading: CircleAvatar(
              backgroundColor: rappel.actif
                  ? const Color(0xFF0074D9)
                  : Colors.grey.shade300,
              child: Icon(
                isMedicament ? Icons.medication : Icons.event,
                color: Colors.white,
              ),
            ),
            title: Text(
              rappel.type,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rappel.actif ? Colors.black : Colors.grey,
              ),
            ),
            subtitle: Text(
              "${_formatDate(rappel.dateHeure)}"
              "${rappel.actif ? "" : "  • Désactivé"}",
              style: TextStyle(
                color: rappel.actif ? Colors.black54 : Colors.grey,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: rappel.actif,
                  onChanged: (value) {
                    context
                        .read<RappelProvider>()
                        .toggleRappel(rappel.id, value);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmDelete(context, rappel.id);
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 85,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 18),
          const Text(
            "Aucun rappel actif",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ajoutez un rappel pour commencer",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} - "
        "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer le rappel"),
          content: const Text("Voulez-vous vraiment supprimer ce rappel ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                context.read<RappelProvider>().deleteRappel(id);
                Navigator.pop(context);
              },
              child: const Text(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openEditRappel(BuildContext context, Rappel rappel) {
    final typeController = TextEditingController(text: rappel.type);
    bool actif = rappel.actif;
    DateTime selectedDate = rappel.dateHeure;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5F7FB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 25,
                bottom: MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Modifier le rappel",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: typeController,
                    decoration: InputDecoration(
                      labelText: "Nom du rappel",
                      prefixIcon: const Icon(Icons.notifications),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: const Icon(Icons.calendar_month),
                    title: const Text("Date"),
                    trailing: Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );

                      if (date != null) {
                        setModalState(() {
                          selectedDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            selectedDate.hour,
                            selectedDate.minute,
                          );
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: const Icon(Icons.access_time),
                    title: const Text("Heure"),
                    trailing: Text(
                      "${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}",
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: selectedDate.hour,
                          minute: selectedDate.minute,
                        ),
                      );

                      if (time != null) {
                        setModalState(() {
                          selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  SwitchListTile(
                    title: const Text(
                      "Activer le rappel",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      "Si désactivé, aucune notification ne sera envoyée.",
                    ),
                    value: actif,
                    activeColor: const Color(0xFF0074D9),
                    onChanged: (value) {
                      setModalState(() {
                        actif = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0074D9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        final updated = rappel.copyWith(
                          type: typeController.text,
                          dateHeure: selectedDate,
                          actif: actif,
                        );

                        context.read<RappelProvider>().updateRappel(updated);
                        Navigator.pop(context);
                      },
                      child: const Text("Mettre à jour"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}