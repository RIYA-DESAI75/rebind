import 'package:flutter/material.dart';
import 'screens/users_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Posts Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF305AB8),
          primary: const Color(0xFF305AB8),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF305AB8),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const UsersScreen(),
    );
  }
}
