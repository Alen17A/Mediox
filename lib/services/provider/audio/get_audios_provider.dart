import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class GetAudiosProvider extends ChangeNotifier {
  List<AudioModel> allAudios = [];
  String searchQuery = "";

  Future<void> getAllAudios() async {
    allAudios = await getSongs();
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    notifyListeners();
  }

  List<AudioModel> filteredSongs() {
    if (searchQuery.isEmpty) {
      return allAudios;
    } else {
      return allAudios.where((audio) {
        return audio.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }
}
