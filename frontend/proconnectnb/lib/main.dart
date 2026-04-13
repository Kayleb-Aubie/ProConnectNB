import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
// Providers
import 'provider/auth_provider.dart';
import 'provider/medication_provider.dart';
import 'provider/activity_provider.dart';

// Navigation
import 'navigation/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
