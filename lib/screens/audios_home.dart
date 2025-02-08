import 'package:flutter/material.dart';
import 'package:mediox/data/functions/store_fetch_audios.dart';
import 'package:mediox/data/models/audio_model.dart';
import 'package:mediox/screens/audio_playback.dart';
import 'package:mediox/services/provider/recently_played.dart';
import 'package:mediox/widgets/floating_bottom_navbar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AudioHome extends StatelessWidget {
  const AudioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: "Search Audios....",
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
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
        body: Stack(
          children: [
            TabBarView(children: [
              FutureBuilder(
                  future: getSongs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(child: Text('No songs found.'));
                    }
                    List<AudioModel> songs = snapshot.data!;
                    return ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        // var song = songs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AudioPlayback(
                                          audioFile: songs,
                                          index: index,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                surfaceTintColor: Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      QueryArtworkWidget(
                                        id: songs[index].audioId,
                                        type: ArtworkType.AUDIO,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(songs[index].title,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,),
                                            Text(
                                              songs[index].artist,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.more_vert),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      },
                    );
                  }),
              Consumer<RecentlyPlayedProvider>(
                  builder: (context, recentlyPlayedProvider, _) {
                if (recentlyPlayedProvider.recentlySongs.isEmpty) {
                  return const Center(child: Text('No recents found.'));
                }
                List<AudioModel> songs = recentlyPlayedProvider.recentlySongs;
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    // var song = songs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AudioPlayback(
                                      audioFile: songs,
                                      index: index,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            surfaceTintColor: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  QueryArtworkWidget(
                                    id: songs[index].audioId,
                                    type: ArtworkType.AUDIO,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          songs[index].title,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          songs[index].artist,
                                          style: const TextStyle(fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.more_vert),
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                );
              }),
              const Icon(Icons.music_note),
              const Icon(Icons.music_note)
            ]),
            const FloatingBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
