import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:provider/provider.dart';

class PlaylistMoreOptions extends StatelessWidget {
  final bool showDelete;
  final String playlistId;
  final String playlistName;
  const PlaylistMoreOptions(
      {super.key,
      required this.playlistId,
      required this.playlistName,
      this.showDelete = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (String value) async {
          switch (value) {
            case "edit":
              String newName = playlistName;
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("New Playlist Name"),
                        content: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: TextField(
                            autofocus: true,
                            onChanged: (value) => newName = value,
                            decoration: const InputDecoration(
                                hintText: "New Playlist Name"),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              if (newName.trim().isNotEmpty &&
                                  newName != playlistName) {
                                await updatePlaylist(
                                  playlistId: playlistId,
                                  newPlaylistName: newName,
                                );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Playlist renamed to $newName"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Provider.of<CustomPlaylistProvider>(context,
                                        listen: false)
                                    .getCustomPlaylistProvider();
                              }
                            },
                            child: const Text("Update"),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                              child: const Text("Close"))
                        ],
                      ));
              break;
            case "delete":
              await deletePlaylist(playlistId: playlistId).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Deleted $playlistName successfully"),
                  backgroundColor: Colors.green,
                ));
              });
              Provider.of<CustomPlaylistProvider>(context, listen: false)
                  .getCustomPlaylistProvider();
              break;
          }
        },
        itemBuilder: (context) => [
              const PopupMenuItem(
                value: "edit",
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit playlist"),
                ),
              ),
              if (showDelete)
                const PopupMenuItem(
                  value: "delete",
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text("Delete playlist"),
                  ),
                ),
            ]);
  }
}
