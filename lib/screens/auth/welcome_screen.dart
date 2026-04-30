import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../widgets/tr_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final auth = context.read<AuthProvider>();

    if (auth.isAine) {
      Navigator.pushReplacementNamed(context, '/dashboardAine');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboardAidant');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF004E92), Color(0xFF000428)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Image.asset('images/logoProConnectNB.png', height: 200),

              const SizedBox(height: 30),

              // TITRE
              const TrText(
                "Bienvenue !",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // SOUS TITRE
              const TrText(
                "Vous êtes maintenant connecté",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),

              const SizedBox(height: 50),

              // BOUTON (OPTIONNEL)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    final auth = context.read<AuthProvider>();

                    if (auth.isAine) {
                      Navigator.pushReplacementNamed(context, '/dashboardAine');
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        '/dashboardAidant',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.white30),
                    ),
                  ),
                  child: const TrText(
                    "Continuer",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
