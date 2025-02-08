import 'package:flutter/material.dart';
import 'package:mediox/data/functions/store_fetch_audios.dart';
import 'package:mediox/screens/audios_home.dart';
import 'package:mediox/services/provider/recently_played.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () => splash(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/MEDIOX_2.png"),
      ),
    );
  }

  Future<void> splash(BuildContext ctx) async {
    await fetchMP3SongsWithHive();
    Provider.of<RecentlyPlayedProvider>(context, listen: false).getRecentlySongsProvider();
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: (context) => const AudioHome()));
  }
}
