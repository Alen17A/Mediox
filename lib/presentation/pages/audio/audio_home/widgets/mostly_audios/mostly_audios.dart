import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/presentation/widgets/audio/listview_audio.dart';
import 'package:provider/provider.dart';

class MostlyPlayed extends StatelessWidget {
  const MostlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MostlyPlayedProvider>(
        builder: (context, mostlyProvider, _) {
      if (mostlyProvider.mostlyPlayed.isEmpty) {
        return const Center(child: Text('No songs'));
      }
      List<AudioModel> songs = mostlyProvider.mostlyPlayed;
      return ListViewAudios(songs: songs);
    });
  }
}
