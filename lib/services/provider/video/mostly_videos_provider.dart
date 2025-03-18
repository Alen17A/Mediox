

import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';

class MostlyVideosProvider extends ChangeNotifier{
  List<VideoModel> mostlyPlayedVideos = [];
  String searchQuery = "";

  Future<void> getMostlyPlayedVideosProvider() async {
    mostlyPlayedVideos = await mostlyVideos();
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    notifyListeners();
  }

  List<VideoModel> filteredVideosMostly() {
    if (searchQuery.isEmpty) {
      return mostlyPlayedVideos;
    } else {
      return mostlyPlayedVideos.where((video) {
        return video.videoTitle
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    }
  }
}