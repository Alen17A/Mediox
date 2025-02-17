import 'package:flutter/material.dart';
import 'package:mediox/data/functions/playlists_audios.dart';
import 'package:mediox/data/functions/store_fetch_audios.dart';
import 'package:mediox/data/models/audio_model.dart';
import 'package:mediox/screens/audio_playback.dart';
import 'package:mediox/services/provider/recently_favourite.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AllAudios extends StatelessWidget {
  const AllAudios({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                            PopupMenuButton(
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: TextButton.icon(
                                          onPressed: () async {
                                            await addSongToPlaylist(
                                                    playlistAudios: [
                                                  songs[index]
                                                ],
                                                    playlistName: "Favourites",
                                                    playlistId: "favourite")
                                                .then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(content: Text("Added to favourites"), backgroundColor: Colors.green,));
                                            });
                                            await Provider.of<
                                                        RecentlyFavouriteProvider>(
                                                    context,
                                                    listen: false)
                                                .getFavouritesProvider();
                                          },
                                          label: const Text(
                                            "Add to favourites",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: DropdownMenu(
                                          dropdownMenuEntries: [
                                            DropdownMenuEntry(
                                                value: 1, label: "Playlist 1"),
                                            DropdownMenuEntry(
                                                value: 2, label: "Playlist 1"),
                                            DropdownMenuEntry(
                                                value: 3, label: "Playlist 1")
                                          ],
                                          label: Text(
                                            "Add to playlists",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          leadingIcon: Icon(
                                            Icons.playlist_add,
                                            color: Colors.green,
                                          ),
                                          width: double.infinity,
                                        ),
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
