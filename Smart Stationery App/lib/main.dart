import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';   // ← Should point to screens folder

void main() {
  runApp(const SmartStationeryApp());
}

class SmartStationeryApp extends StatelessWidget {
  const SmartStationeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Stationery Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}