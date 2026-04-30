import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/tr_text.dart';

import '../../provider/auth_provider.dart';
import '../../provider/medication_provider.dart';
import '../../provider/activity_provider.dart';
import '../../provider/caregiver_provider.dart';
import '../../provider/aine_provider.dart';
import '../../provider/rappel_provider.dart';
import '../../provider/appointment_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final meds = context.watch<MedicationProvider>();
    final activity = context.watch<ActivityProvider>();
    final caregivers = context.watch<CaregiverProvider>();
    final aines = context.watch<AineProvider>();
    final rappelProvider = context.watch<RappelProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();

    final activeMeds = meds.medications.where((m) => m.isActive).toList();
    final remainingMeds = activeMeds.where((m) => !m.isTaken).length;

    final activeReminders = meds.activeMedications.length;
    final relationCount = auth.isAine
        ? caregivers.caregivers.length
        : aines.aines.length;

    // Labels dynamiques pour la traduction
    final relationLabel = auth.isAine ? "Aidants" : "Aînés";
    final relationIcon = auth.isAine ? Icons.people : Icons.elderly;

    final progress = activity.isLoading
        ? 0.0
        : activity.todayActivity.progressRatio;

    final rappelsDuJour = rappelProvider.rappelsDuJour;
    final rendezVousDuJour = appointmentProvider.appointmentsDuJour;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context, auth),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF405667), Color(0xFF506778)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopHeader(auth),
              const SizedBox(height: 12),
              _buildDatePill(),
              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard(
                      value: remainingMeds.toString().padLeft(2, '0'),
                      label: "À prendre",
                      icon: Icons.medication,
                      color: const Color(0xFF8370D8),
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      value: activeReminders.toString().padLeft(2, '0'),
                      label: "Rappels",
                      icon: Icons.notifications_active,
                      color: const Color(0xFF5D95D6),
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      value: relationCount.toString().padLeft(2, '0'),
                      label: relationLabel,
                      icon: relationIcon,
                      color: const Color(0xFF51A091),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAF8F4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _sectionHeader(
                          "Activité du jour",
                          "Voir détails ↗",
                          () => Navigator.pushNamed(context, '/activities'),
                        ),
                        const SizedBox(height: 10),

                        _activityCard(progress, activity),

                        const SizedBox(height: 18),

                        _sectionHeader(
                          "Médicaments du jour",
                          "Tout voir ↗",
                          () => Navigator.pushNamed(context, '/medications'),
                        ),
                        const SizedBox(height: 10),

                        if (meds.medications.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: TrText(
                              "Aucun médicament ajouté",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          ...meds.medications
                              .take(3)
                              .map((med) => _medicationTile(context, med)),

                        const SizedBox(height: 12),

                        _warningCard(remainingMeds),

                        const SizedBox(height: 18),

                        _sectionHeader(
                          "Rappels du jour",
                          "Tout voir ↗",
                          () => Navigator.pushNamed(context, '/rappel'),
                        ),
                        const SizedBox(height: 10),

                        if (rappelsDuJour.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: TrText(
                              "Aucun rappel aujourd’hui",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          ...rappelsDuJour
                              .take(3)
                              .map((rappel) => _rappelTile(rappel)),

                        const SizedBox(height: 18),

                        _sectionHeader(
                          "Rendez-vous du jour",
                          "Tout voir ↗",
                          () => Navigator.pushNamed(context, '/appointments'),
                        ),
                        const SizedBox(height: 10),

                        if (rendezVousDuJour.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: TrText(
                              "Aucun rendez-vous aujourd’hui",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          ...rendezVousDuJour
                              .take(3)
                              .map((rdv) => _appointmentTile(rdv)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          const SizedBox(width: 4),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TrText(
                  "Bienvenue",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TrText(
                  auth.firstName ?? "Utilisateur",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/editprofil'),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white24,
              child: ClipOval(
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: _buildHeaderImage(auth),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePill() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month, color: Colors.white70, size: 14),
            SizedBox(width: 6),
            TrText(
              "Mercredi, 29 avril 2026",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 104,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white.withOpacity(0.18),
              child: Icon(icon, color: Colors.white, size: 13),
            ),
            // Les chiffres (value) restent en Text simple car ils ne se traduisent pas
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            TrText(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String action, VoidCallback onTap) {
    return Row(
      children: [
        TrText(
          title,
          style: const TextStyle(
            color: Color(0xFF59534D),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: TrText(
            action,
            style: const TextStyle(
              color: Color(0xFF5D95D6),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _activityCard(double progress, ActivityProvider activity) {
    final steps = activity.isLoading ? 0 : activity.todayActivity.steps;
    final goal = activity.isLoading ? 10000 : activity.todayActivity.stepGoal;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFEA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 65,
            height: 65,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor: Colors.white,
                  color: const Color(0xFF6DB3F2),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    color: Color(0xFF6DB3F2),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TrText(
                  "Objectif Quotidien",
                  style: TextStyle(
                    color: Color(0xFF7A746E),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "$steps pas",
                  style: const TextStyle(
                    color: Color(0xFF504A45),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Row(
                  children: [
                    const TrText(
                      "Objectif : ",
                      style: TextStyle(
                        color: Color(0xFF7A746E),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$goal pas",
                      style: const TextStyle(
                        color: Color(0xFF7A746E),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.white,
                  color: const Color(0xFF6DB3F2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _medicationTile(BuildContext context, Medication med) {
    final isTaken = med.isTaken;
    final isActive = med.isActive;

    return Opacity(
      opacity: isActive ? 1 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFF1EFEA),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 4,
              backgroundColor: !isActive
                  ? Colors.grey
                  : isTaken
                  ? const Color(0xFF6FC27B)
                  : const Color(0xFFEF6A5A),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${med.name} ${med.dosage}",
                    style: TextStyle(
                      color: isActive ? const Color(0xFF4E4944) : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      decoration: isActive ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${med.time} - ",
                        style: const TextStyle(
                          color: Color(0xFF8A8178),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TrText(
                        isActive
                            ? (isTaken ? "pris" : "à prendre")
                            : "désactivé",
                        style: const TextStyle(
                          color: Color(0xFF8A8178),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (isActive)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isTaken ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isTaken
                      ? const Color(0xFF61B66D)
                      : const Color(0xFFFF6B3D),
                  size: 22,
                ),
                onPressed: () {
                  context.read<MedicationProvider>().toggleTaken(med.id);
                },
              )
            else
              const TrText(
                "Inactif",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _warningCard(int remainingMeds) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E6),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFFFC98E)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF8A3D)),
          const SizedBox(width: 10),
          Expanded(
            child: TrText(
              remainingMeds > 0
                  ? "$remainingMeds médicament(s) actif(s) restant(s)\nN’oubliez pas vos prises."
                  : "Tout est à jour !\nAucun médicament actif restant.",
              style: const TextStyle(
                color: Color(0xFFE9703D),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(AuthProvider auth) {
    final imagePath = auth.profilePicture;

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        return Image.network(
          imagePath,
          key: ValueKey(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, color: Colors.white),
        );
      }

      return Image.file(
        File(imagePath),
        key: ValueKey(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.person, color: Colors.white),
      );
    }

    return const Icon(Icons.person, color: Colors.white);
  }

  Widget _buildDrawer(BuildContext context, AuthProvider auth) {
    return Drawer(
      backgroundColor: const Color(0xFF001F3F),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF001429)),
            child: Center(
              child: Image.asset('images/logoProConnectNB.png', height: 125),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  Icons.dashboard,
                  "Tableau de bord",
                  () => Navigator.pop(context),
                  isActive: true,
                ),

                const Divider(color: Colors.white24, indent: 20, endIndent: 20),

                _drawerItem(
                  Icons.medication,
                  "Médicaments",
                  () => Navigator.pushNamed(context, '/medications'),
                ),

                _drawerItem(
                  Icons.directions_run,
                  "Activités",
                  () => Navigator.pushNamed(context, '/activities'),
                ),

                _drawerItem(
                  auth.isAine ? Icons.people : Icons.elderly,
                  auth.isAine ? "Proche aidant" : "Aînés",
                  () => Navigator.pushNamed(
                    context,
                    auth.isAine ? '/caregiver' : '/aine',
                  ),
                ),

                const Divider(color: Colors.white24, indent: 20, endIndent: 20),

                _drawerItem(
                  Icons.notifications_active,
                  "Rappels",
                  () => Navigator.pushNamed(context, '/rappel'),
                ),

                _drawerItem(
                  Icons.calendar_month,
                  "Rendez-vous",
                  () => Navigator.pushNamed(context, '/appointments'),
                ),

                const Divider(color: Colors.white24, indent: 20, endIndent: 20),

                _drawerItem(
                  Icons.settings,
                  "Paramètres",
                  () => Navigator.pushNamed(context, '/settings'),
                ),

                _drawerItem(Icons.help_outline, "Aide & Support", () {}),
              ],
            ),
          ),

          const Divider(color: Colors.white24),

          _drawerItem(Icons.logout, "Se déconnecter", () async {
            await auth.logout();

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            }
          }, color: Colors.redAccent),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.white,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: TrText(
        title,
        style: TextStyle(
          color: color,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _rappelTile(dynamic rappel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFEA),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Color(0xFF5D95D6)),
          const SizedBox(width: 12),
          Expanded(
            child: TrText(
              rappel
                  .type, // Assurez-vous que rappel.type correspond à une clé JSON
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF4E4944),
              ),
            ),
          ),
          Text(
            "${rappel.dateHeure.hour.toString().padLeft(2, '0')}:${rappel.dateHeure.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF001F3F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentTile(dynamic rdv) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFEA),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Color(0xFF51A091)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrText(
                  rdv.docteur,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4E4944),
                  ),
                ),
                TrText(
                  rdv.lieu,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A8178),
                  ),
                ),
              ],
            ),
          ),
          TrText(
            "${rdv.dateHeure.hour.toString().padLeft(2, '0')}:${rdv.dateHeure.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF001F3F),
            ),
          ),
        ],
      ),
    );
  }
}
