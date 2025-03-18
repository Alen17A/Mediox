import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/video/video_home/widgets/videos_search.dart';

class VideoAppBar extends StatelessWidget {
  const VideoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.blue,
      title: const Row(
        children: [
          Expanded(
            child: VideosSearch(),
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
    );
  }
}
