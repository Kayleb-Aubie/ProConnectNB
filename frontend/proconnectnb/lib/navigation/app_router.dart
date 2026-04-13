import 'package:flutter/material.dart';

// Screens
import '../screens/auth/login_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/test/api_test_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case '/medications':
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Médicaments"))),
        );

      case '/activities':
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Activités"))),
        );

      case '/caregiver':
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Proche aidant"))),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Paramètres"))),
        );

      //case '/apiTest':
      // return MaterialPageRoute(builder: (_) => const ApiTestScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Page not found"))),
        );
    }
  }
}
