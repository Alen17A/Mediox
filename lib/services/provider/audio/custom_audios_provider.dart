import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class CustomAudiosProvider extends ChangeNotifier {
  List<AudioModel> customAudios = [];

  Future<void> getCustomAudiosProvider(String? playlistId) async {
    customAudios = await getCustomAudios(playlistId!);
    notifyListeners();
  }
}
