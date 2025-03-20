import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/services/provider/video/custom_playlists_videos_provider.dart';
import 'package:mediox/services/provider/video/custom_videos_provider.dart';
import 'package:mediox/services/provider/video/recently_favourite_videos.dart';
import 'package:provider/provider.dart';

class MoreOptionsVideo extends StatelessWidget {
  const MoreOptionsVideo(
      {super.key,
      required this.videos,
      required this.index,
      required this.playlistId,
      this.showDelete = true, this.inPlaylist = true});

  final List<VideoModel> videos;
  final int index;
  final String? playlistId;
  final bool showDelete;
  final bool inPlaylist;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
            if(inPlaylist)
              PopupMenuItem(
                child: TextButton.icon(
                  onPressed: () async {
                    await addVideoToPlaylist(
                            playlistVideos: [videos[index]],
                            playlistName: "Favourites",
                            playlistId: "favourite")
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Added to favourites"),
                        backgroundColor: Colors.green,
                      ));
                    });
                    await Provider.of<RecentlyFavouriteVideosProvider>(context,
                            listen: false)
                        .getFavouritesVideosProvider();
                  },
                  label: const Text(
                    "Add to favourites",
                  ),
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ),
              PopupMenuItem(
                child: Consumer<CustomPlaylistsVideosProvider>(
                  builder: (context, customPlaylistVideosProvider, _) =>
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
                                            await addVideoToPlaylist(
                                                    playlistVideos: [
                                                  videos[index]
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
                                            Provider.of<CustomPlaylistsVideosProvider>(
                                                    context,
                                                    listen: false)
                                                .getCustomPlaylistVideosProvider();
                                          }
                                        },
                                        child: const Text("OK")),
                                    ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Close"))
                                  ],
                                ));
                      } else {
                        await addVideoToPlaylist(
                                playlistVideos: [videos[index]],
                                playlistName: playlistName,
                                playlistId: playlistId)
                            .then((_) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Added to Playlist"),
                            backgroundColor: Colors.green,
                          ));
                        });
                        Provider.of<CustomPlaylistsVideosProvider>(context,
                                listen: false)
                            .getCustomPlaylistVideosProvider();
                        Provider.of<CustomVideosProvider>(context,
                                listen: false)
                            .getCustomVideosProvider(playlistId);
                      }
                    },
                    items: [
                      const DropdownMenuItem(
                        value: "0",
                        child: Text("Create new playlist",
                            style: TextStyle(color: Colors.green)),
                      ),
                      ...List.generate(
                        customPlaylistVideosProvider
                            .customPlaylistsVideos.length,
                        (index) {
                          return DropdownMenuItem(
                            value: customPlaylistVideosProvider
                                .customPlaylistsVideos[index].playlistId,
                            child: Text(customPlaylistVideosProvider
                                .customPlaylistsVideos[index].playlistName),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (showDelete)
                PopupMenuItem(
                  child: TextButton.icon(
                    onPressed: () async {
                      await removeVideosFromPlaylists(
                              videoId: videos[index].videoId,
                              playlistId: playlistId)
                          .then((_) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "${videos[index].videoTitle} deleted successfully"),
                          backgroundColor: Colors.green,
                        ));
                      });
                      Provider.of<CustomVideosProvider>(context, listen: false)
                          .getCustomVideosProvider(playlistId);
                      Provider.of<RecentlyFavouriteVideosProvider>(context,
                              listen: false)
                          .getFavouritesVideosProvider();
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
