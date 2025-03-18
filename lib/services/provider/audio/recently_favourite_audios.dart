import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class RecentlyFavouriteAudiosProvider extends ChangeNotifier {
  List<AudioModel> recentlySongs = [];
  List<AudioModel> favouriteAudios = [];
  String searchQuery = "";

  Future<void> getRecentlySongsProvider() async {
    recentlySongs = await getRecentlySongs();
    notifyListeners();
  }

  Future<void> getFavouritesProvider() async {
    favouriteAudios = await getFavouriteAudios();
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    notifyListeners();
  }

  List<AudioModel> filteredSongsRecents() {
    if (searchQuery.isEmpty) {
      return recentlySongs;
    } else {
      return recentlySongs.where((audio) {
        return audio.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  List<AudioModel> filteredSongsFavourites() {
    if (searchQuery.isEmpty) {
      return favouriteAudios;
    } else {
      return favouriteAudios.where((audio) {
        return audio.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  bool isFavourite(int audioId) {
    return favouriteAudios.any((audio) => audio.audioId == audioId);
  }

  void toggleFavourites(AudioModel audio) {
    if (isFavourite(audio.audioId)) {
      favouriteAudios.removeWhere((item) => item.audioId == audio.audioId);
    } else {
      favouriteAudios.add(audio);
    }
    notifyListeners();
  }
}
