import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🎉 Icône ou image
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),

              const SizedBox(height: 20),

              // 👋 Message
              const Text(
                "Bienvenue !",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Connexion réussie à votre compte",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // 🔘 Continuer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  child: const Text("Continuer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}