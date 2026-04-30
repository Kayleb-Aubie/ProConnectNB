import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/rappel.dart';
import '../../provider/rappel_provider.dart';
import '../../widgets/rappels/add_rappel_form.dart';
import '../../widgets/tr_text.dart';

class AddRappelScreen extends StatelessWidget {
  const AddRappelScreen({super.key});

  void _addRappel(BuildContext context, String type, DateTime date, bool isMed) {
    final rappel = Rappel(
      id: DateTime.now().millisecondsSinceEpoch,
      type: type,
      dateHeure: date,
      actif: true,
      medicamentId: isMed ? 1 : null,
      rendezVousMedicalId: isMed ? null : 1,
    );

    context.read<RappelProvider>().addRappel(rappel);

    Navigator.pop(context); // retourne à la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TrText("Ajouter un rappel"),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AddRappelForm(
          onSubmit: (type, date, isMed) {
            _addRappel(context, type, date, isMed);
          },
        ),
      ),
    );
  }
}