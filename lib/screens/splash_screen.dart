import 'package:flutter/material.dart';
import 'package:mediox/screens/audios_home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    splash(context);
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/MEDIOX.png"),
      ),
    );
  }

  Future<void> splash(BuildContext ctx) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: (context) => const AudioHome()));
  }
}
