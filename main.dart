import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DeltaBotApp());
}

class DeltaBotApp extends StatelessWidget {
  const DeltaBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DeltaBot Monitor",
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}
