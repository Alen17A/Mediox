import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audios_playlist_model.dart';

class CustomPlaylistProvider extends ChangeNotifier {
  List<AudioPlaylistModel> customPlaylists = [];

  Future<void> getCustomPlaylistProvider() async {
    customPlaylists = await getPlaylists();
    notifyListeners();
  }
}
