import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/presentation/pages/audio/all_audios/all_audios.dart';
import 'package:mediox/presentation/pages/audio/all_playlists/all_playlists_audios.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/audios_search.dart';
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: TextButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const AudioHome())),
                child: Image.asset(
                  gifMode,
                  width: 900,
                  height: 900,
                ),
              )),
              ListTile(
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (bool newValue) {
                    themeProvider.toggleTheme(newValue);
                  },
                  activeColor: Colors.green,
                ),
              ),
              ListTile(
                title: const Text("Sync Audios"),
                trailing: const Icon(Icons.sync),
                onTap: () async {
                  await fetchMP3SongsWithHive();
                  Provider.of<GetAudiosProvider>(context, listen: false)
                      .getAllAudios();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Audios synced successfully"),
                    backgroundColor: Colors.green,
                  ));
                },
              ),
              ListTile(
                title: const Text("Privacy Policy"),
                trailing: const Icon(Icons.privacy_tip_outlined),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Privacy Policy"),
                            content: const Text(
                                "Mediox is designed solely to play audio and video files that are already stored on your device. We do not collect, store, or transmit any personal data or your media content. The permissions requested are used exclusively to access and display the media files you already have. No media file or personal data is sent to any external server or third party."),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"))
                            ],
                          ));
                },
              ),
              ListTile(
                title: const Text("Contact Us"),
                trailing: const Icon(Icons.call),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Contact Us"),
                            content: const Text(
                                "If you have any queries or suggestions, feel free to reach out to me via email at alenjdeveloper@gmail.com. I appreciate your feedback and look forward to improving the app to enhance your experience."),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"))
                            ],
                          ));
                },
              ),
              ListTile(
                title: const Text("About Us"),
                trailing: const Icon(Icons.person),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("About Us"),
                            content: const Text(
                                "My aim is to build one of the best and most efficient applications that help people feel relaxed. Through innovation and simplicity, I strive to create user-friendly apps that bring ease and comfort to everyday life."),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"))
                            ],
                          ));
                },
              )
            ],
          ),
        ),
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
