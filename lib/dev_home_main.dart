import 'package:flutter/material.dart';

// Kendi oluşturduğun sayfaları import ediyorsun
import 'theme.dart';
import 'screens/root_screen.dart';

void main() {
  runApp(const DevHomeApp());
}

class DevHomeApp extends StatelessWidget {
  const DevHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusConnect (Home Dev)',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const RootScreen(), 
    );
  }
}
