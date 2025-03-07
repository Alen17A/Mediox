import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/data/models/audio/audios_playlist_model.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/data/models/video/video_playlist_model.dart';
import 'package:mediox/presentation/pages/splash_screen/splash_screen.dart';
import 'package:mediox/services/provider/audio/custom_audios_provider.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:mediox/services/provider/video/custom_playlists_videos_provider.dart';
import 'package:mediox/services/provider/video/custom_videos_provider.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
import 'package:mediox/services/provider/video/mostly_videos_provider.dart';
import 'package:mediox/services/provider/video/recently_favourite_videos.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AudioModelAdapter().typeId) ||
      !Hive.isAdapterRegistered(AudioPlaylistModelAdapter().typeId) ||
      !Hive.isAdapterRegistered(VideoModelAdapter().typeId) || !Hive.isAdapterRegistered(VideoPlaylistModelAdapter().typeId)) {
    Hive.registerAdapter(AudioModelAdapter());
    Hive.registerAdapter(AudioPlaylistModelAdapter());
    Hive.registerAdapter(VideoModelAdapter());
    Hive.registerAdapter(VideoPlaylistModelAdapter());
  }
  audioBox = await Hive.openLazyBox<AudioModel>('audioBox');
  playlistModelAudioBox =
      await Hive.openLazyBox<AudioPlaylistModel>('playlistAudioBox');
  videoBox = await Hive.openLazyBox<VideoModel>("videoBox");
  playlistModelVideoBox =
      await Hive.openLazyBox<VideoPlaylistModel>('playlistVideoBox');
  runApp(const Mediox());
}

class Mediox extends StatelessWidget {
  const Mediox({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GetAudiosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecentlyFavouriteAudiosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MostlyPlayedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomPlaylistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomAudiosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetVideosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecentlyFavouriteVideosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MostlyVideosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomPlaylistsVideosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomVideosProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
