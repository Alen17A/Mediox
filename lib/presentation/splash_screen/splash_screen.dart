import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/presentation/audio/audio_home/audios_home.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
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
    await fetchVideosWithHive();
    await fetchMP3SongsWithHive();
    Provider.of<GetAudiosProvider>(context, listen: false)
        .getAllAudios();
    Provider.of<RecentlyFavouriteProvider>(context, listen: false)
        .getRecentlySongsProvider();
    Provider.of<RecentlyFavouriteProvider>(context, listen: false)
        .getFavouritesProvider();
    Provider.of<MostlyPlayedProvider>(context, listen: false)
        .getMostlyPlayedProvider();
    Provider.of<CustomPlaylistProvider>(context, listen: false)
        .getCustomPlaylistProvider();
    Provider.of<GetVideosProvider>(context, listen: false)
        .getAllVideos();
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: (context) => const AudioHome()));
  }
}
