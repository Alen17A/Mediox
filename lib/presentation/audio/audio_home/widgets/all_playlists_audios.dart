import 'package:flutter/material.dart';
import 'package:mediox/presentation/audio/audio_favourites/favourites_audio.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:provider/provider.dart';

class AllPlaylists extends StatelessWidget {
  const AllPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              return ListView.builder(itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      customPlaylistProvider.customPlaylists[index].playlistName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
          
                  ),
                  
                );
              }, itemCount: customPlaylistProvider.customPlaylists.length,
              shrinkWrap: true,);
            })
          ],
        ),
      ),
    );
  }
}
