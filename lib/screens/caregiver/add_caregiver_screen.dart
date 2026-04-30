import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/caregiver.dart';
import '../../provider/caregiver_provider.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/tr_text.dart';

class AddCaregiverScreen extends StatefulWidget {
  final Caregiver? caregiver; // Optionnel : présent seulement en mode modification
  const AddCaregiverScreen({super.key, this.caregiver});

  @override
  State<AddCaregiverScreen> createState() => _AddCaregiverScreenState();
}

class _AddCaregiverScreenState extends State<AddCaregiverScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs
  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    // Initialisation avec les valeurs existantes ou vide
    _nomCtrl = TextEditingController(text: widget.caregiver?.nom ?? '');
    _prenomCtrl = TextEditingController(text: widget.caregiver?.prenom ?? '');
    _telCtrl = TextEditingController(text: widget.caregiver?.telephone ?? '');
    _emailCtrl = TextEditingController(text: widget.caregiver?.email ?? '');
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<CaregiverProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final data = {
      "nom": _nomCtrl.text.trim(),
      "prenom": _prenomCtrl.text.trim(),
      "telephone": _telCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
    };

    bool success;
    if (widget.caregiver == null) {
      // Mode AJOUT
      success = await provider.addCaregiver(
        nom: data["nom"]!,
        prenom: data["prenom"]!,
        telephone: data["telephone"]!,
        email: data["email"]!,
        auth: auth,
      );
    } else {
      // Mode MODIFICATION
      success = await provider.updateCaregiver(widget.caregiver!.id, data, auth);
    }

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.caregiver != null;

    return Scaffold(
      appBar: AppBar(
        title: TrText(isEditing ? "Modifier le proche" : "Ajouter un proche"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildField(_prenomCtrl, "Prénom", Icons.person),
            _buildField(_nomCtrl, "Nom", Icons.person_outline),
            _buildField(_telCtrl, "Téléphone", Icons.phone, type: TextInputType.phone),
            _buildField(_emailCtrl, "Email", Icons.email, type: TextInputType.emailAddress),
            
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A3AFF),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: TrText(
                isEditing ? "METTRE À JOUR" : "ENREGISTRER",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF4A3AFF)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (v) => v == null || v.isEmpty ? "Obligatoire" : null,
      ),
    );
  }
}