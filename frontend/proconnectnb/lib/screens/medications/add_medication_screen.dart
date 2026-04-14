import 'package:flutter/material.dart';
import '../../services/api.dart';

class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final Api api = Api();

  final _formKey = GlobalKey<FormState>();

  String nom = "";
  String dosage = "";
  String frequence = "";

  void save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final success = await api.addMedication({
        "nom": nom,
        "dosage": dosage,
        "frequence": frequence,
      });

      if (success) {
        Navigator.pop(context);
      } else {
        print("Erreur ajout");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter médicament")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nom"),
                onSaved: (value) => nom = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Dosage"),
                onSaved: (value) => dosage = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Fréquence"),
                onSaved: (value) => frequence = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: save,
                child: Text("Ajouter"),
              )
            ],
          ),
        ),
      ),
    );
  }
}