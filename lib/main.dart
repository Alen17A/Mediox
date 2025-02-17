import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/functions/playlists_audios.dart';
import 'package:mediox/data/functions/store_fetch_audios.dart';
import 'package:mediox/data/models/audio_model.dart';
import 'package:mediox/data/models/audios_playlist_model.dart';
import 'package:mediox/screens/splash_screen.dart';
import 'package:mediox/services/provider/mostly_played_provider.dart';
import 'package:mediox/services/provider/recently_favourite.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AudioModelAdapter().typeId) ||
      !Hive.isAdapterRegistered(AudioPlaylistModelAdapter().typeId)) {
    Hive.registerAdapter(AudioModelAdapter());
    Hive.registerAdapter(AudioPlaylistModelAdapter());
  }
  audioBox = await Hive.openLazyBox<AudioModel>('audioBox');
  playlistModelAudioBox =
      await Hive.openLazyBox<AudioPlaylistModel>('playlistAudioBox');
  runApp(const Mediox());
}

class Mediox extends StatelessWidget {
  const Mediox({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RecentlyFavouriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MostlyPlayedProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
