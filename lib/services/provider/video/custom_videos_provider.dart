

import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';

class CustomVideosProvider extends ChangeNotifier{
  List<VideoModel> customVideos = [];

  Future<void> getCustomVideosProvider(String? playlistId) async {
    customVideos = await getCustomVideos(playlistId!);
    notifyListeners();
  }
}