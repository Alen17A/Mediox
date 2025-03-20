import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/widgets/audio/audio_tile.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:provider/provider.dart';

class MostlyPlayed extends StatelessWidget {
  const MostlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    const String category = "Mostly Played";
    return Consumer<MostlyPlayedProvider>(
        builder: (context, mostlyProvider, _) {
      List<AudioModel> songs = mostlyProvider.filteredSongsMostly();
      if (songs.isEmpty) {
        return const Center(child: Text('No songs found.'));
      }
      return AudioTile(songs: songs, category: category,);
    });
  }
}
