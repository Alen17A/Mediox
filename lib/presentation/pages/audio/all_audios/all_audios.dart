import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/widgets/audio/audio_tile.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:provider/provider.dart';

class AllAudios extends StatelessWidget {
  const AllAudios({super.key});

  @override
  Widget build(BuildContext context) {
    const String category = "All Audios";
    return Consumer<GetAudiosProvider>(
        builder: (context, allAudiosProvider, _) {
      List<AudioModel> songs = allAudiosProvider.filteredSongs();
      if (songs.isEmpty) {
        return const Center(child: Text('No songs found.'));
      }
      return AudioTile(
        songs: songs,
        showMoreOptions: true,
        showDelete: false,
        category: category,
      );
    });
  }
}
