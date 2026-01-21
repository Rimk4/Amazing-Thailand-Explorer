import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class AmazingThailandExplorerApp extends StatelessWidget {
  const AmazingThailandExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazing Thailand Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
