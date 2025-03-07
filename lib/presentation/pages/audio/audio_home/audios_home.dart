import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/all_audios/all_audios.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/all_playlists/all_playlists_audios.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/audios_search.dart';
import 'package:mediox/presentation/widgets/floating_bottom_navbar.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/mostly_audios/mostly_audios.dart';
import 'package:mediox/presentation/pages/audio/audio_home/widgets/recently_audios/recently_audios.dart';

class AudioHome extends StatelessWidget {
  const AudioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.grey,
          surfaceTintColor: const Color(0xff2E6F40),
          title: const Row(
            children: [
              Expanded(
                child: AudiosSearch()
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: TextButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const AudioHome())),
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
            TabBarView(children: [
              AllAudios(),
              RecentlyAudios(),
              MostlyPlayed(),
              AllPlaylists(),
            ]),
            FloatingBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
