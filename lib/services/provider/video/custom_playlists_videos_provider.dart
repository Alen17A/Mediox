import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/data/models/video/video_playlist_model.dart';

class CustomPlaylistsVideosProvider extends ChangeNotifier {
  List<VideoPlaylistModel> customPlaylistsVideos = [];

  Future<void> getCustomPlaylistVideosProvider() async {
    customPlaylistsVideos = await getVideosPlaylists();
    notifyListeners();
  }
}
