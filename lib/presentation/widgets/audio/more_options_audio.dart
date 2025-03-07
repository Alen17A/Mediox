import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/services/provider/audio/custom_audios_provider.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:provider/provider.dart';

class MoreOptionsAudio extends StatelessWidget {
  const MoreOptionsAudio({
    super.key,
    required this.songs,
    required this.playlistId,
    required this.index
  });

  final List<AudioModel> songs;
  final String? playlistId;
  final int index;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                child: TextButton.icon(
                  onPressed: () async {
                    await addSongToPlaylist(
                            playlistAudios: [songs[index]],
                            playlistName: "Favourites",
                            playlistId: "favourite")
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Added to favourites"),
                        backgroundColor: Colors.green,
                      ));
                    });
                    await Provider.of<RecentlyFavouriteAudiosProvider>(context,
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
                  builder: (context, customPlaylistProvider, _) =>
                      DropdownButton(
                    value: "0",
                    onChanged: (playlistId) async {
                      String playlistName = '';
                      if (playlistId == "0") {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Create new playlist",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  content: TextField(
                                    onChanged: (value) => playlistName = value,
                                    decoration: const InputDecoration(
                                        hintText: "Playlist Name"),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (playlistName.trim().isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Enter a name for the playlist"),
                                              backgroundColor: Colors.red,
                                            ));
                                          } else {
                                            await addSongToPlaylist(
                                                    playlistAudios: [
                                                  songs[index]
                                                ],
                                                    playlistName: playlistName)
                                                .then((_) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Playlist $playlistName created"),
                                                backgroundColor: Colors.green,
                                              ));
                                            });
                                            Provider.of<CustomPlaylistProvider>(
                                                    context,
                                                    listen: false)
                                                .getCustomPlaylistProvider();
                                          }
                                        },
                                        child: const Text("OK")),
                                    ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Close"))
                                  ],
                                ));
                      } else {
                        await addSongToPlaylist(
                                playlistAudios: [songs[index]],
                                playlistId: playlistId)
                            .then((_) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Added to playlist"),
                            backgroundColor: Colors.green,
                          ));
                        });
                        Provider.of<CustomPlaylistProvider>(context,
                                listen: false)
                            .getCustomPlaylistProvider();
                        // Provider.of<CustomAudiosProvider>(
                        //         context,
                        //         listen: false)
                        //     .getCustomAudiosProvider(
                        //         playlistId);
                      }
                    },
                    items: [
                      const DropdownMenuItem(
                        value: "0",
                        child: Text("Create new playlist",
                            style: TextStyle(color: Colors.green)),
                      ),
                      ...List.generate(
                        customPlaylistProvider.customPlaylists.length,
                        (index) {
                          return DropdownMenuItem(
                            value: customPlaylistProvider
                                .customPlaylists[index].playlistId,
                            child: Text(customPlaylistProvider
                                .customPlaylists[index].playlistName),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                child: TextButton.icon(
                  onPressed: () async {
                    await removeFromPlaylists(
                            audioId: songs[index].audioId,
                            playlistId: playlistId)
                        .then((_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${songs[index].title} deleted successfully"),
                        backgroundColor: Colors.green,
                      ));
                    });
                    Provider.of<CustomAudiosProvider>(context, listen: false)
                        .getCustomAudiosProvider(playlistId);
                  },
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
            ]);
  }
}
