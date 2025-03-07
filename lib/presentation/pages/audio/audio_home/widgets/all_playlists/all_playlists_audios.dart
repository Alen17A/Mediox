import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/audio/audio_custom_playlists/custom_audios.dart';
import 'package:mediox/presentation/pages/audio/audio_favourites/favourites_audio.dart';
import 'package:mediox/services/provider/audio/custom_audios_provider.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:provider/provider.dart';

class AllPlaylists extends StatelessWidget {
  const AllPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                overlayColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 197, 120, 115)),
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavouritesAudio()));
                },
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.grey,
                  surfaceTintColor: Colors.red,
                  child: ListTile(
                    leading: Icon(
                      Icons.favorite_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Favourites",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Consumer<CustomPlaylistProvider>(
                  builder: (context, customPlaylistProvider, _) {
                final audios = customPlaylistProvider.customPlaylists;
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Provider.of<CustomAudiosProvider>(context,
                                listen: false)
                            .getCustomAudiosProvider(audios[index].playlistId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomAudios(
                                      playlistName: audios[index].playlistName,
                                      playListId: audios[index].playlistId,
                                    )));
                      },
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.grey,
                        surfaceTintColor: Colors.green,
                        child: ListTile(
                          title: Text(
                            customPlaylistProvider
                                .customPlaylists[index].playlistName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: customPlaylistProvider.customPlaylists.length,
                  shrinkWrap: true,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
