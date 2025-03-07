import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/presentation/pages/audio/audio_home/audios_home.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:mediox/services/provider/video/custom_playlists_videos_provider.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
import 'package:mediox/services/provider/video/mostly_videos_provider.dart';
import 'package:mediox/services/provider/video/recently_favourite_videos.dart';
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
    Provider.of<GetAudiosProvider>(context, listen: false).getAllAudios();
    Provider.of<RecentlyFavouriteAudiosProvider>(context, listen: false)
        .getRecentlySongsProvider();
    Provider.of<RecentlyFavouriteAudiosProvider>(context, listen: false)
        .getFavouritesProvider();
    Provider.of<MostlyPlayedProvider>(context, listen: false)
        .getMostlyPlayedProvider();
    Provider.of<CustomPlaylistProvider>(context, listen: false)
        .getCustomPlaylistProvider();
    Provider.of<GetVideosProvider>(context, listen: false).getAllVideos();
    Provider.of<RecentlyFavouriteVideosProvider>(context, listen: false)
        .getRecentlyVideosProvider();
    Provider.of<RecentlyFavouriteVideosProvider>(context, listen: false)
        .getFavouritesVideosProvider();
    Provider.of<MostlyVideosProvider>(context, listen: false)
        .getMostlyPlayedVideosProvider();
    Provider.of<CustomPlaylistsVideosProvider>(context, listen: false)
        .getCustomPlaylistVideosProvider();
    Navigator.pushReplacement(
        ctx, MaterialPageRoute(builder: (context) => const AudioHome()));
  }
}
