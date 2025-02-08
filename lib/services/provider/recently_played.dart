import 'package:flutter/foundation.dart';
import 'package:mediox/data/functions/playlists_audios.dart';
import 'package:mediox/data/models/audio_model.dart';

class RecentlyPlayedProvider extends ChangeNotifier {
  List<AudioModel> recentlySongs = [];

  Future<void> getRecentlySongsProvider() async {
    recentlySongs = await getRecentlySongs();
    notifyListeners();
  }
}
