import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/widgets/audio/audio_tile.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:provider/provider.dart';

class RecentlyAudios extends StatelessWidget {
  const RecentlyAudios({super.key});

  @override
  Widget build(BuildContext context) {
    const String category = "Recently Played";
    return Consumer<RecentlyFavouriteAudiosProvider>(
        builder: (context, recentlyPlayedProvider, _) {
      List<AudioModel> songs = recentlyPlayedProvider.filteredSongsRecents();
      if (songs.isEmpty) {
        return const Center(child: Text('No recents found.'));
      }
      return AudioTile(
        songs: songs,
        category: category,
      );
    });
  }
}
