import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/aine.dart';
import '../../provider/caregiver_provider.dart';
import '../../provider/aine_provider.dart';
import '../../provider/partage_provider.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/tr_text.dart';

class PartageScreen extends StatefulWidget {
  final dynamic initialData; // Reçoit un objet Aine ou null

  const PartageScreen({super.key, this.initialData});

  @override
  State<PartageScreen> createState() => _PartageScreenState();
}

class _PartageScreenState extends State<PartageScreen> {
  int? _selectedTargetId;
  String _selectedRelation = "Fils / Fille";

  final List<String> _relations = [
    "Fils / Fille",
    "Conjoint(e)",
    "Parent",
    "Ami(e)",
    "Autre",
  ];

  @override
  void initState() {
    super.initState();
    // Si on passe un aîné au constructeur, on le sélectionne par défaut
    if (widget.initialData != null && widget.initialData is Aine) {
      _selectedTargetId = (widget.initialData as Aine).id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isAineConnecte = auth.isAine; // Utilise ton getter booléen

    final caregiverProv = Provider.of<CaregiverProvider>(context);
    final aineProv = Provider.of<AineProvider>(context);
    final partageProv = Provider.of<PartageProvider>(context);

    // Définir la liste à afficher selon le rôle
    // Si AINE : il veut voir les PROCHES. Si AIDANT : il veut voir les AÎNÉS.
    final List<DropdownMenuItem<int>> items = isAineConnecte
        ? caregiverProv.caregivers
              .map(
                (c) => DropdownMenuItem(
                  value: c.id,
                  child: Text("${c.prenom} ${c.nom}"),
                ),
              )
              .toList()
        : aineProv.aines
              .map(
                (a) => DropdownMenuItem(
                  value: a.id,
                  child: Text("${a.prenom} ${a.nom}"),
                ),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: TrText(
          isAineConnecte ? "Partager avec un proche" : "Suivre un aîné",
        ),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrText(
              isAineConnecte
                  ? "Sélectionnez le proche aidant :"
                  : "Sélectionnez l'aîné à suivre :",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Le Dropdown
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                filled: widget.initialData != null, // Gris si déjà sélectionné
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(
                  isAineConnecte ? Icons.person_add : Icons.elderly,
                  color: const Color(0xFF4A3AFF),
                ),
              ),
              value: _selectedTargetId,
              hint: TrText(
                isAineConnecte ? "Choisir un proche" : "Choisir un aîné",
              ),
              items: items,
              // On désactive le changement si on vient déjà d'une fiche spécifique
              onChanged: widget.initialData != null
                  ? null
                  : (val) {
                      setState(() => _selectedTargetId = val);
                    },
            ),

            const SizedBox(height: 25),
            const TrText(
              "Quelle est votre relation ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Sélecteur de relation (Chips)
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _relations.map((rel) {
                final isSelected = _selectedRelation == rel;
                return ChoiceChip(
                  label: Text(rel),
                  selected: isSelected,
                  selectedColor: const Color(0xFF4A3AFF),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedRelation = rel);
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            // Bouton de validation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A3AFF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (_selectedTargetId == null || partageProv.isLoading)
                    ? null
                    : () async {
                        bool success;

                        if (isAineConnecte) {
                          // Cas : L'aîné invite un proche
                          success = await partageProv.aineAjouteProche(
                            aineId: auth.currentUserLocalId ?? 0,
                            procheId: _selectedTargetId!,
                            relation: _selectedRelation,
                            auth: auth,
                          );
                        } else {
                          // Cas : Le proche demande à suivre un aîné
                          success = await partageProv.procheInviteAine(
                            aineId: _selectedTargetId!,
                            procheAidantId: auth.currentUserLocalId ?? 0,
                            relation: _selectedRelation,
                            auth: auth,
                          );
                        }

                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: TrText("Lien créé avec succès !"),
                            ),
                          );
                          Navigator.pop(context);
                        } else if (mounted && partageProv.error.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(partageProv.error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: partageProv.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const TrText(
                        "CONFIRMER LE LIEN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
