import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:mediox/presentation/widgets/audio/listview_audio.dart';
import 'package:provider/provider.dart';

class AllAudios extends StatelessWidget {
  const AllAudios({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GetAudiosProvider>(
        builder: (context, allAudiosProvider, _) {
      // if (snapshot.connectionState == ConnectionState.waiting) {
      //   return const Center(child: CircularProgressIndicator());
      // }
      // List<AudioModel> songs = allAudiosProvider.allAudios;
      List<AudioModel> songs = allAudiosProvider.filteredSongs();
      if (songs.isEmpty) {
        return const Center(child: Text('No songs found.'));
      }
      return ListViewAudios(songs: songs, showMoreOptions: true,);
    });
  }
}
