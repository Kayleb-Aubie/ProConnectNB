import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Message
            const Text(
              "Bonjour 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            //Carte Médicaments
            _buildCard(
              title: "Médicaments",
              icon: Icons.medication,
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/medications');
              },
            ),

            const SizedBox(height: 15),

            // Carte Activités
            _buildCard(
              title: "Activités",
              icon: Icons.event,
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/activities');
              },
            ),

            const SizedBox(height: 15),

            //Carte Proche aidant
            _buildCard(
              title: "Proche aidant",
              icon: Icons.people,
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/caregiver');
              },
            ),

            const SizedBox(height: 15),

            // Paramètres
            _buildCard(
              title: "Paramètres",
              icon: Icons.settings,
              color: Colors.grey,
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  //Widget carte réutilisable
  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}