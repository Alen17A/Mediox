import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/widgets/audio/audio_tile.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:provider/provider.dart';

class FavouritesAudio extends StatelessWidget {
  const FavouritesAudio({super.key});

  @override
  Widget build(BuildContext context) {
    const String category = "Favourites";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites", style: TextStyle(fontWeight: FontWeight.bold),),
        elevation: 5,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.red,
      ),
      body: Consumer<RecentlyFavouriteAudiosProvider>(
          builder: (context, favouritesProvider, _) {
        if (favouritesProvider.favouriteAudios.isEmpty) {
          return const Center(child: Text('No favourites'));
        }
        List<AudioModel> songs = favouritesProvider.favouriteAudios;
        return AudioTile(
          songs: songs,
          playlistId: "favourite",
          category: category,
          showMoreOptions: true,
          inPlaylist: false,
        );
      }),
    );
  }
}
