import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'services/bookmark_service.dart';
import 'screens/landing_screen.dart';
import 'screens/main_nav_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter(); // inisialisasi hive
    if (!Hive.isBoxOpen('users')) {
      await Hive.openBox('users'); // buka box users
    }
    if (!Hive.isBoxOpen('user_emails')) {
      await Hive.openBox('user_emails'); // buka box user_emails
    }
  } catch (e) {
    debugPrint('Hive init error: $e');
  }

  final isLoggedIn = await FavoriteService.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty Multiverse Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: isLoggedIn ? const MainNavScreen() : const LandingScreen(),
    );
  }
}