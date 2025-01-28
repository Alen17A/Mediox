import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/screens/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const Mediox());
}

class Mediox extends StatelessWidget {
  const Mediox({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
