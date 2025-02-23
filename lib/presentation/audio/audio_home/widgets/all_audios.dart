import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/audio/audio_playback/audio_playback.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AllAudios extends StatelessWidget {
  const AllAudios({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GetAudiosProvider>(
        builder: (context, allAudiosProvider, _) {
      // if (snapshot.connectionState == ConnectionState.waiting) {
      //   return const Center(child: CircularProgressIndicator());
      // }
      List<AudioModel> songs = allAudiosProvider.allAudios;
      if (songs.isEmpty) {
        return const Center(child: Text('No songs found.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: songs.length,
        itemBuilder: (context, index) {
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
              padding: const EdgeInsets.all(5),
              child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey,
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
                              Text(
                                songs[index].title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                        PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        await addSongToPlaylist(
                                                playlistAudios: [songs[index]],
                                                playlistName: "Favourites",
                                                playlistId: "favourite")
                                            .then((_) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("Added to favourites"),
                                            backgroundColor: Colors.green,
                                          ));
                                        });
                                        await Provider.of<
                                                    RecentlyFavouriteProvider>(
                                                context,
                                                listen: false)
                                            .getFavouritesProvider();
                                      },
                                      label: const Text(
                                        "Add to favourites",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: Consumer<CustomPlaylistProvider>(
                                      builder: (context, customPlaylistProvider,
                                              _) =>
                                          DropdownButton(
                                        value: "0",
                                        onChanged: (playlistId) async {
                                          String playlistName = "";
                                          if (playlistId == "0") {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                        "Create new playlist",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      content: TextField(
                                                        onChanged: (value) =>
                                                            playlistName =
                                                                value,
                                                        decoration:
                                                            const InputDecoration(
                                                                hintText:
                                                                    "Playlist Name"),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (playlistName
                                                                  .trim()
                                                                  .isEmpty) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  content: Text(
                                                                      "Enter a name for the playlist"),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ));
                                                              } else {
                                                                await addSongToPlaylist(
                                                                    playlistAudios: [
                                                                      songs[
                                                                          index]
                                                                    ],
                                                                    playlistName:
                                                                        playlistName);
                                                                Provider.of<CustomPlaylistProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getCustomPlaylistProvider();
                                                              }
                                                            },
                                                            child: const Text(
                                                                "OK")),
                                                        ElevatedButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                "Close"))
                                                      ],
                                                    ));
                                          } else {
                                            await addSongToPlaylist(
                                                playlistAudios: [songs[index]],
                                                playlistName: playlistName,
                                                playlistId: playlistId);
                                            Provider.of<CustomPlaylistProvider>(
                                                    context,
                                                    listen: false)
                                                .getCustomPlaylistProvider();
                                          }
                                        },
                                        items: [
                                          const DropdownMenuItem(
                                            value: "0",
                                            child: Text("Create new playlist",
                                                style: TextStyle(
                                                    color: Colors.green)),
                                          ),
                                          ...List.generate(
                                            customPlaylistProvider
                                                .customPlaylists.length,
                                            (index) {
                                              return DropdownMenuItem(
                                                value: customPlaylistProvider
                                                    .customPlaylists[index]
                                                    .playlistId,
                                                child: Text(
                                                    customPlaylistProvider
                                                        .customPlaylists[index]
                                                        .playlistName),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    // child: Text(
                                    //   "Add to playlists",
                                    //   style:
                                    //       TextStyle(color: Colors.green),
                                    // ),
                                    // leadingIcon: Icon(
                                    //   Icons.playlist_add,
                                    //   color: Colors.green,
                                    // ),
                                    // width: double.infinity,
                                  ),
                                  PopupMenuItem(
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      label: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ]),
                      ],
                    ),
                  )),
            ),
          );
        },
      );
    });
  }
}
