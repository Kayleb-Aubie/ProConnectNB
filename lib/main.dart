import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'provider/auth_provider.dart';
import 'provider/medication_provider.dart';
import 'provider/activity_provider.dart';
import 'provider/caregiver_provider.dart';
import 'provider/rappel_provider.dart';
import 'provider/settings_provider.dart';
import 'provider/aine_provider.dart';
import 'provider/appointment_provider.dart';
import 'provider/partage_provider.dart';
import 'navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => CaregiverProvider()),
        ChangeNotifierProvider(create: (_) => RappelProvider()),
        ChangeNotifierProvider(create: (_) => AineProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
ChangeNotifierProvider(create: (_) => PartageProvider()),
        // SettingsProvider chargé avant runApp
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/startup',
      onGenerateRoute: AppRouter.generateRoute,

      locale: settings.locale,
      supportedLocales: const [Locale('fr'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: settings.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.primaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: settings.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.primaryColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Roboto',
      ),

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaleFactor: settings.fontSize),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
