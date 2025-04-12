import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/presentation/pages/audio/all_audios/all_audios.dart';
import 'package:mediox/presentation/pages/audio/all_playlists/all_playlists_audios.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/audios_search.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/menu.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/widgets/miniplayer_audio.dart';
import 'package:mediox/presentation/widgets/floating_bottom_navbar.dart';
import 'package:mediox/presentation/pages/audio/mostly_audios/mostly_audios.dart';
import 'package:mediox/presentation/pages/audio/recently_audios/recently_audios.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:mediox/services/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class AudioHome extends StatelessWidget {
  const AudioHome({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String gifMode = isDark
        ? "assets/gifs/MEDIOX_dark_bg_removed.gif"
        : "assets/gifs/MEDIOX_light_bg_removed.gif";

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.grey,
          surfaceTintColor: const Color(0xff2E6F40),
          title: const Row(
            children: [
              Expanded(child: AudiosSearch()),
            ],
          ),
          toolbarHeight: 80,
          bottom: const TabBar(
              padding: EdgeInsets.symmetric(horizontal: 10),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Color(0xff2E6F40),
              dividerColor: Colors.transparent,
              labelColor: Color(0xff2E6F40),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(),
              tabs: [
                Tab(
                  text: "All Songs",
                ),
                Tab(
                  text: "Recently Played",
                ),
                Tab(
                  text: "Mostly Played",
                ),
                Tab(
                  text: "Playlists",
                ),
              ]),
        ),
        drawer: Menu(gifMode: gifMode, themeProvider: themeProvider),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [Colors.green, Colors.white],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                  ),
            ),
            const TabBarView(children: [
              AllAudios(),
              RecentlyAudios(),
              MostlyPlayed(),
              AllPlaylists(),
            ]),
            const FloatingBottomNavBar(),
            const MiniplayerAudio(),
          ],
        ),
      ),
    );
  }
}
