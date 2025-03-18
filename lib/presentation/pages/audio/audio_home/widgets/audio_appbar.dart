import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/audios_search.dart';

class AudioAppbar extends StatelessWidget {
  const AudioAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        elevation: 5,
        shadowColor: Colors.grey,
        surfaceTintColor: const Color(0xff2E6F40),
        title: const Row(
          children: [
            Expanded(
              child: AudiosSearch(),
            ),
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
    );
  }
}
