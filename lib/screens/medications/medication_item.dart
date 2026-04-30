import 'package:flutter/material.dart';
import '../../widgets/tr_text.dart';

class MedicationItem extends StatelessWidget {
  final String id;
  final String nom;
  final String marque;
  final String dosage;
  final String frequence;
  final bool isActive;

  final Function(bool) onToggle;
  final VoidCallback onDelete;

  const MedicationItem({
    super.key,
    required this.id,
    required this.nom,
    required this.marque,
    required this.dosage,
    required this.frequence,
    required this.isActive,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,

      // 🔴 BACKGROUND DELETE
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      // 🔥 CONFIRMATION
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const TrText("Supprimer"),
            content: const TrText("Supprimer ce médicament ?"),
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

      onDismissed: (_) => onDelete(),

      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isActive ? const Color(0xFF7CD4FD) : Colors.grey,
            child: const Icon(Icons.medication, color: Colors.white),
          ),

          title: TrText(
            "$nom ($marque)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: isActive ? null : TextDecoration.lineThrough,
            ),
          ),

          subtitle: TrText("Dosage: $dosage • Fréquence: $frequence"),

          //  TOGGLE ACTIF
          trailing: Switch(
            value: isActive,
            onChanged: onToggle,
            activeColor: const Color(0xFF0052D4),
          ),
        ),
      ),
    );
  }
}
