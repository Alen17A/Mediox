import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/widgets/audio/audio_tile.dart';
import 'package:mediox/services/provider/audio/custom_audios_provider.dart';
import 'package:provider/provider.dart';

class CustomAudios extends StatelessWidget {
  final String playlistName;
  final String playListId;
  const CustomAudios({super.key, required this.playlistName, required this.playListId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName, style: const TextStyle(fontWeight: FontWeight.bold),),
        elevation: 5,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.green,
      ),
      body: Consumer<CustomAudiosProvider>(
          builder: (context, customAudiosProvider, _) {
        if (customAudiosProvider.customAudios.isEmpty) {
          return const Center(child: Text('No songs'));
        }
        List<AudioModel> songs = customAudiosProvider.customAudios;
        return AudioTile(
          songs: songs,
          showMoreOptions: true,
          playlistId: playListId,
        );
      }),
    );
  }
}
