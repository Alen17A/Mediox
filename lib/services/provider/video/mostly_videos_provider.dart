

import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';

class MostlyVideosProvider extends ChangeNotifier{
  List<VideoModel> mostlyPlayedVideos = [];

  Future<void> getMostlyPlayedVideosProvider() async {
    mostlyPlayedVideos = await mostlyVideos();
    notifyListeners();
  }
}