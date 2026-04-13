import 'package:flutter/material.dart';

// Auth
import '../screens/auth/login_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/add_user_screen.dart';

// Dashboard
import '../screens/dashboard/dashboard_screen.dart';

// Test API (optionnel)
import '../screens/test/api_test_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/addUser':
        return MaterialPageRoute(builder: (_) => const AddUserScreen());

      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case '/apiTest':
        return MaterialPageRoute(builder: (_) => const ApiTestScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page non trouvée")),
          ),
        );
    }
  }
}