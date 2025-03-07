import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/video/video_home/videos_search.dart';
import 'package:mediox/presentation/pages/video/video_home/widgets/all_playlists_videos/all_playlists_videos.dart';
import 'package:mediox/presentation/pages/video/video_home/widgets/all_videos/all_videos.dart';
import 'package:mediox/presentation/pages/video/video_home/widgets/mostly_videos/mostly_videos.dart';
import 'package:mediox/presentation/pages/video/video_home/widgets/recently_videos/recently_videos.dart';
import 'package:mediox/presentation/widgets/floating_bottom_navbar.dart';

class VideoHome extends StatelessWidget {
  const VideoHome({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset("assets/images/MEDIOX_2.png"),
              )),
              ListTile(
                title: const Text("Settings"),
                trailing: const Icon(Icons.settings),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Help"),
                trailing: const Icon(Icons.help),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Contact Us"),
                trailing: const Icon(Icons.call),
                onTap: () {},
              ),
              ListTile(
                title: const Text("About Us"),
                trailing: const Icon(Icons.person),
                onTap: () {},
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
            FloatingBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
