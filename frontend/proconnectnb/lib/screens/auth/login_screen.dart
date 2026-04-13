import 'package:flutter/material.dart';
import 'package:proconnectnb/services/api.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004E92), Color(0xFF000428)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Image.asset('images/logoProConnectNB.png', height: 250),

                  const SizedBox(height: 40),

                  // --- CARTE ---
                  Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "CONNEXION",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004E92),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // EMAIL / USERNAME
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.alternate_email),
                                labelText: "Courriel ou Identifiant",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? "Champ requis" : null,
                            ),
                            const SizedBox(height: 20),

                            // PASSWORD
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                labelText: "Mot de passe",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? "Champ requis" : null,
                            ),
                            const SizedBox(height: 30),

                            // BOUTON LOGIN
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF004E92),
                                    Color(0xFF000428),
                                  ],
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "SE CONNECTER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Forgot password
                            TextButton(
                              onPressed: () {},
                              child: const Text("Mot de passe oublié ?"),
                            ),

                            // Create account
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/addUser');
                              },
                              child: const Text(
                                "Créer un compte",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004E92),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // LOGIQUE LOGIN
  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      final auth = Provider.of<AuthProvider>(context, listen: false);

      bool success = await auth.login(email, password);

      if (success) {
        Navigator.pushReplacementNamed(context, '/welcome');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Identifiants invalides")));
      }
    }
  }
}
