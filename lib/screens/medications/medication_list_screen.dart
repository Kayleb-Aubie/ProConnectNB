import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/medication_provider.dart';
import 'add_medication_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final Set<String> _selectedIds = {};
  bool _isDeleting = false;

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (_selectedIds.isEmpty) return;

    setState(() => _isDeleting = true);

    final provider = context.read<MedicationProvider>();

    bool allSuccess = true;

    for (final id in _selectedIds.toList()) {
      final success = await provider.deleteMedication(id);
      if (!success) allSuccess = false;
    }

    if (!mounted) return;

    setState(() {
      _isDeleting = false;
      _selectedIds.clear();
    });

    _showSnackBar(
      allSuccess ? "Traitements supprimés" : "Erreur lors de la suppression",
      isError: !allSuccess,
    );
  }

  Future<void> _deleteOne(String id) async {
    final provider = context.read<MedicationProvider>();
    final success = await provider.deleteMedication(id);

    if (!mounted) return;

    _showSnackBar(
      success ? "Traitement supprimé" : "Erreur lors de la suppression",
      isError: !success,
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  void _openEditScreen(Medication med) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddMedicationScreen(
          id: med.id,
          initialName: med.name,
          initialDosage: med.dosage,
          initialTime: med.time,
          initialIsActive: med.isActive,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          Positioned(
            top: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x260052D4), Color(0x000052D4)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Consumer<MedicationProvider>(
                    builder: (context, provider, child) {
                      final meds = provider.medications;

                      if (meds.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        itemCount: meds.length,
                        itemBuilder: (context, index) {
                          final med = meds[index];
                          final isSelected = _selectedIds.contains(med.id);

                          return _buildMedicationCard(
                            med: med,
                            isSelected: isSelected,
                            provider: provider,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: _selectedIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isDeleting ? null : _deleteSelected,
              backgroundColor: const Color(0xFFEF4444),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ),
              label: Text(
                "Supprimer (${_selectedIds.length})",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddMedicationScreen(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF0052D4),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                "Nouveau Traitement",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (_selectedIds.isNotEmpty) {
                setState(() => _selectedIds.clear());
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D0F172A),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _selectedIds.isNotEmpty
                    ? Icons.close_rounded
                    : Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),

          Text(
            _selectedIds.isNotEmpty
                ? "${_selectedIds.length} sélectionné(s)"
                : "Traitements",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Aucun traitement en cours",
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMedicationCard({
    required Medication med,
    required bool isSelected,
    required MedicationProvider provider,
  }) {
    return Dismissible(
      key: ValueKey(med.id),
      direction: DismissDirection.endToStart,

      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(right: 24),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),

      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Supprimer"),
            content: Text("Supprimer ${med.name} ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                ),
                child: const Text(
                  "Supprimer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },

      onDismissed: (_) => _deleteOne(med.id),

      child: GestureDetector(
        onTap: () {
          if (_selectedIds.isNotEmpty) {
            _toggleSelection(med.id);
          } else {
            _openEditScreen(med);
          }
        },
        onLongPress: () => _toggleSelection(med.id),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0F9FF) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? const Color(0xFF0052D4) : Colors.transparent,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: med.isActive
                      ? const Color(0x1A0052D4)
                      : const Color(0xFFE5E7EB),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: med.isActive
                      ? const Color(0xFF0052D4)
                      : const Color(0xFF94A3B8),
                  size: 26,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: med.isActive
                            ? const Color(0xFF0F172A)
                            : const Color(0xFF94A3B8),
                        decoration: med.isActive
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.monitor_weight_outlined,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          med.dosage,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          med.time,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      med.isActive ? "Rappel actif" : "Rappel désactivé",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: med.isActive
                            ? const Color(0xFF10B981)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              Switch(
                value: med.isActive,
                activeColor: const Color(0xFF0052D4),
                onChanged: (value) {
                  provider.toggleActive(med.id, value);
                },
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: () => _toggleSelection(med.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0052D4)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0052D4)
                          : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
