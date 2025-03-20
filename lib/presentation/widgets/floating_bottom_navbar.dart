import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/presentation/pages/audio/audio_home/audios_home.dart';
import 'package:mediox/presentation/pages/video/video_home/videos_home.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:mediox/services/provider/video/custom_playlists_videos_provider.dart';
import 'package:provider/provider.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final bool isVideo;
  const FloatingBottomNavBar({super.key, this.isVideo = false});

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);
    final TextEditingController playlistTextController =
        TextEditingController();
    if (isVideo) {
      return AnimatedBuilder(
        animation: tabController,
        builder: (context, child) {
          final int currentIndex = tabController.index;
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: const EdgeInsets.all(8),
                // height: 95,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 40, 42, 68).withAlpha(229),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        spreadRadius: 5,
                      )
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AudioHome()));
                        },
                        label: const Text(
                          "Audios",
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: const Icon(
                          Icons.audiotrack_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (currentIndex == 3)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title:
                                            const Text("Create New Playlist"),
                                        content: TextField(
                                          controller: playlistTextController,
                                          decoration: const InputDecoration(
                                              hintText: "Playlist Name"),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                String playlistName =
                                                    playlistTextController.text;
                                                if (playlistName
                                                    .trim()
                                                    .isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Enter a name for the playlist"),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                } else {
                                                  if (isVideo) {
                                                    await addVideoToPlaylist(
                                                            playlistName:
                                                                playlistName)
                                                        .then((_) {
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            "Playlist $playlistName created"),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ));
                                                    });
                                                    Provider.of<CustomPlaylistsVideosProvider>(
                                                            context,
                                                            listen: false)
                                                        .getCustomPlaylistVideosProvider();
                                                  } else {
                                                    await addSongToPlaylist(
                                                            playlistName:
                                                                playlistName)
                                                        .then((_) {
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            "Playlist $playlistName created"),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ));
                                                    });
                                                    Provider.of<CustomPlaylistProvider>(
                                                            context,
                                                            listen: false)
                                                        .getCustomPlaylistProvider();
                                                  }
                                                }
                                              },
                                              child: const Text("OK")),
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Close"))
                                        ],
                                      ));
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 40,
                            )),
                      ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VideoHome()));
                        },
                        label: const Text(
                          "Videos",
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: const Icon(
                          Icons.video_camera_back_outlined,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                )),
          );
        },
      );
    }
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        final int currentIndex = tabController.index;
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              padding: const EdgeInsets.all(8),
              // height: 95,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0XFF253D2C).withAlpha(229),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AudioHome()));
                      },
                      label: const Text(
                        "Audios",
                        style: TextStyle(color: Colors.black),
                      ),
                      icon: const Icon(
                        Icons.audiotrack_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (currentIndex == 3)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Create New Playlist"),
                                      content: TextField(
                                        controller: playlistTextController,
                                        decoration: const InputDecoration(
                                            hintText: "Playlist Name"),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              String playlistName =
                                                  playlistTextController.text;
                                              if (playlistName.trim().isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Enter a name for the playlist"),
                                                  backgroundColor: Colors.red,
                                                ));
                                              } else {
                                                if (isVideo) {
                                                  await addVideoToPlaylist(
                                                          playlistName:
                                                              playlistName)
                                                      .then((_) {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Playlist $playlistName created"),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                  });
                                                  Provider.of<CustomPlaylistsVideosProvider>(
                                                          context,
                                                          listen: false)
                                                      .getCustomPlaylistVideosProvider();
                                                } else {
                                                  await addSongToPlaylist(
                                                          playlistName:
                                                              playlistName)
                                                      .then((_) {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Playlist $playlistName created"),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                  });
                                                  Provider.of<CustomPlaylistProvider>(
                                                          context,
                                                          listen: false)
                                                      .getCustomPlaylistProvider();
                                                }
                                              }
                                            },
                                            child: const Text("OK")),
                                        ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Close"))
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 40,
                          )),
                    ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VideoHome()));
                      },
                      label: const Text(
                        "Videos",
                        style: TextStyle(color: Colors.black),
                      ),
                      icon: const Icon(
                        Icons.video_camera_back_outlined,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
