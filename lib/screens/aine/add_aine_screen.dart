import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/aine_provider.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/tr_text.dart';
import '../../models/aine.dart';

class AddAineScreen extends StatefulWidget {
  final Aine? aine;
  const AddAineScreen({super.key, this.aine});

  @override
  State<AddAineScreen> createState() => _AddAineScreenState();
}

class _AddAineScreenState extends State<AddAineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _docteurCtrl = TextEditingController();
  final _telDocteurCtrl = TextEditingController();

  // Adresse
  final _rueCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _cpCtrl = TextEditingController();

  DateTime _selectedDate = DateTime(1950);

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void initState() {
    super.initState();
    // Si on est en mode édition, on remplit les champs
    if (widget.aine != null) {
      _nomCtrl.text = widget.aine!.nom;
      _prenomCtrl.text = widget.aine!.prenom;
      _telCtrl.text = widget.aine!.telephone;
      _emailCtrl.text = widget.aine!.email;
      _docteurCtrl.text = widget.aine!.docteur;
      _telDocteurCtrl.text = widget.aine!.numeroDocteur;
      _selectedDate = widget.aine!.dateNaissance;

      if (widget.aine!.adresse != null) {
        _rueCtrl.text = widget.aine!.adresse!.rue ?? '';
        _villeCtrl.text = widget.aine!.adresse!.ville ?? '';
        _cpCtrl.text = widget.aine!.adresse!.codePostal ?? '';
      }
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<AineProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final data = {
      "nom": _nomCtrl.text.trim(),
      "prenom": _prenomCtrl.text.trim(),
      "telephone": _telCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
      "dateNaissance": _selectedDate.toIso8601String(),
      "docteur": _docteurCtrl.text.trim(),
      "numeroTelephoneDocteur": _telDocteurCtrl.text.trim(),
      "adresse": {
        "rue": _rueCtrl.text.trim(),
        "ville": _villeCtrl.text.trim(),
        "codePostal": _cpCtrl.text.trim(),
      },
    };

    bool success;
    if (widget.aine == null) {
      success = await provider.addAine(data, auth);
    } else {
      // Appel de la méthode de mise à jour
      success = await provider.updateAine(widget.aine!.id, data, auth);
    }

    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TrText("Ajouter un aîné")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle("Informations Vitales"),
            _buildField(_prenomCtrl, "Prénom", Icons.person),
            _buildField(_nomCtrl, "Nom", Icons.person_outline),

            ListTile(
              title: const TrText("Date de naissance"),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              leading: const Icon(
                Icons.calendar_today,
                color: Color(0xFF4A3AFF),
              ),
              onTap: _pickDate,
              trailing: const Icon(Icons.edit, size: 20),
            ),

            const Divider(),
            _buildSectionTitle("Contact"),
            _buildField(
              _telCtrl,
              "Téléphone",
              Icons.phone,
              type: TextInputType.phone,
            ),
            _buildField(
              _emailCtrl,
              "Email",
              Icons.email,
              type: TextInputType.emailAddress,
            ),

            const Divider(),
            _buildSectionTitle("Santé"),
            _buildField(
              _docteurCtrl,
              "Médecin de famille",
              Icons.medical_services,
            ),
            _buildField(
              _telDocteurCtrl,
              "Téléphone médecin",
              Icons.local_hospital,
              type: TextInputType.phone,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A3AFF),
              ),
              child: const TrText(
                "ENREGISTRER",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TrText(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF64748B),
      ),
    ),
  );

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: (v) => v!.isEmpty ? "Obligatoire" : null,
    );
  }
}
