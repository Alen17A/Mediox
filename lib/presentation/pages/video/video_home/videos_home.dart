import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/presentation/pages/video/video_home/widgets/videos_search.dart';
import 'package:mediox/presentation/pages/video/all_playlists_videos/all_playlists_videos.dart';
import 'package:mediox/presentation/pages/video/all_videos/all_videos.dart';
import 'package:mediox/presentation/pages/video/mostly_videos/mostly_videos.dart';
import 'package:mediox/presentation/pages/video/recently_videos/recently_videos.dart';
import 'package:mediox/presentation/widgets/floating_bottom_navbar.dart';
import 'package:mediox/services/provider/theme_provider.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
import 'package:provider/provider.dart';

class VideoHome extends StatelessWidget {
  const VideoHome({super.key});

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
          shadowColor: Colors.black,
          surfaceTintColor: Colors.blue,
          title: const Row(
            children: [
              Expanded(
                child: VideosSearch()
              ),
            ],
          ),
          toolbarHeight: 80,
          bottom: const TabBar(
              padding: EdgeInsets.symmetric(horizontal: 10),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Color.fromARGB(255, 15, 105, 178),
              dividerColor: Colors.transparent,
              labelColor: Color.fromARGB(255, 15, 105, 178),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(),
              tabs: [
                Tab(
                  text: "All Videos",
                ),
                Tab(
                  text: "Recently Watched",
                ),
                Tab(
                  text: "Mostly Watched",
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
                    MaterialPageRoute(builder: (context) => const VideoHome())),
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
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                  activeColor: Colors.green,
                ),
              ),
              ListTile(
                title: const Text("Sync Videos"),
                trailing: const Icon(Icons.sync),
                onTap: () async{
                  await fetchVideosWithHive();
                  Provider.of<GetVideosProvider>(context, listen: false)
                      .getAllVideos();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Videos synced successfully"),
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
        body: const Stack(
          children: [
            TabBarView(
              children: [
              AllVideos(),
              RecentlyVideos(),
              MostlyVideos(),
              AllPlaylistsVideos(),
            ]),
            FloatingBottomNavBar(isVideo: true,),
          ],
        ),
      ),
    );
  }
}
