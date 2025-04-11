import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class MostlyPlayedProvider extends ChangeNotifier {
  List<AudioModel> mostlyPlayed = [];
  String searchQuery = "";

  Future<void> getMostlyPlayedProvider() async {
    mostlyPlayed = await mostlyAudios();
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    notifyListeners();
  }

  List<AudioModel> filteredSongsMostly() {
    if (searchQuery.isEmpty) {
      return mostlyPlayed;
    } else {
      return mostlyPlayed.where((audio) {
        return audio.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }
}
