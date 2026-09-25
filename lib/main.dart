// 📦 main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DulcePecadoApp());
}

class DulcePecadoApp extends StatelessWidget {
  const DulcePecadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dulce Pecado Ltda 🍪',
      theme: ThemeData(
        // 🎨 Paleta de colores base
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        scaffoldBackgroundColor: const Color(0xFFFFF8E7),

        // 🧁 AppBar personalizado
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown.shade400,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 3,
          titleTextStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),

        // 🔘 Botones uniformes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 📝 Fuente general
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.brown, fontSize: 14, height: 1.4),
        ),
      ),

      // 🏠 Pantalla inicial
      home: const HomeScreen(),
    );
  }
}
