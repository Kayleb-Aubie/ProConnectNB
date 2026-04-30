import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/activity_provider.dart';
import '../../widgets/tr_text.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _stepsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final int steps = int.tryParse(_stepsController.text.trim()) ?? 0;

      final provider = context.read<ActivityProvider>();
      await provider.addSteps(steps);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const TrText("Activité enregistrée avec succès"),
          backgroundColor: const Color(0xFF10B981),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const TrText("Une erreur s'est produite"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildActivityInfoCard(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // APPBAR
  // =========================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const TrText(
        "Ajouter une activité",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  // =========================
  // FORM CARD
  // =========================
  Widget _buildActivityInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TrText(
            "Détails de l'effort",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _buildTextField(
            controller: _stepsController,
            label: "Nombre de pas",
            icon: Icons.directions_walk,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _durationController,
            label: "Durée (minutes)",
            icon: Icons.timer,
          ),
        ],
      ),
    );
  }

  // =========================
  // TEXT FIELD
  // =========================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_isLoading,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Champ requis";
        }
        return null;
      },
    );
  }

  // =========================
  // BUTTON
  // =========================
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveActivity,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const TrText("Enregistrer l'activité"),
    );
  }
}
