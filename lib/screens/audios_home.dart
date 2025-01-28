import 'package:flutter/material.dart';
import 'package:mediox/widgets/floating_bottom_navbar.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioHome extends StatefulWidget {
  const AudioHome({super.key});

  @override
  State<AudioHome> createState() => _AudioHomeState();
}

class _AudioHomeState extends State<AudioHome> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  checkPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(retryRequest: retry);

    _hasPermission ? setState(() {}) : null;
  }

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
                child: Image.asset("assets/images/MEDIOX.png"),
              )),
              ListTile(
                title: const Text("Settings"),
                trailing: const Icon(Icons.settings),
                onTap: () {},
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(children: [
              !_hasPermission
                  ? Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 179, 82, 75),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          const Text(
                              "Mediox currently do not has the permission to access your media. Please allow to grant permission."),
                          ElevatedButton(
                              onPressed: () => checkPermissions(retry: true),
                              child: const Text("Allow"))
                        ],
                      ),
                    )
                  : FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(),
                      builder: (context, item) {
                        if (item.hasError) {
                          item.error.toString();
                        }
                        if (item.data == null) {
                          return const CircularProgressIndicator();
                        }
                        if (item.data!.isEmpty) {
                          return const Text("Nothing Found!!");
                        }
                        return ListView.builder(
                          itemCount: item.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    child: Row(
                                  children: [
                                    const Icon(Icons.music_note),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(item.data![index].title,
                                              style: const TextStyle(
                                                  fontSize: 24)),
                                          Text(
                                            item.data![index].artist!,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.more_vert),
                                  ],
                                )),
                              ),
                            );
                          },
                        );
                      }),
              const Icon(Icons.music_note),
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
