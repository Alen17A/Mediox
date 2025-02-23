import 'package:flutter/foundation.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class RecentlyFavouriteProvider extends ChangeNotifier {
  List<AudioModel> recentlySongs = [];
  List<AudioModel> favouriteAudios = [];

  Future<void> getRecentlySongsProvider() async {
    recentlySongs = await getRecentlySongs();
    notifyListeners();
  }

  Future<void> getFavouritesProvider() async {
    favouriteAudios = await getFavouriteAudios();
    notifyListeners();
  }
}
