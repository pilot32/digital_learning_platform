import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'database/seed_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
void main() async {
  // Initialize FFI for sqflite
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database with seed data
  await SeedData.seedDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}
 
