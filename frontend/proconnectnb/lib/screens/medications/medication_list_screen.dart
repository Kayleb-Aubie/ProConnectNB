import 'package:flutter/material.dart';
import '../../services/api.dart';

class MedicationListScreen extends StatefulWidget {
  @override
  _MedicationListScreenState createState() =>
      _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final Api api = Api();
  List medications = [];

  @override
  void initState() {
    super.initState();
    loadMedications();
  }

  void loadMedications() async {
    final data = await api.getMedications();
    setState(() {
      medications = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Médicaments")),
      body: Center(
        child: Text("Test"),
      )
    );
  }
}