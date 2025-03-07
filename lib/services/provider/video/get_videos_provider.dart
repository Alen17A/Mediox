import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';

class GetVideosProvider extends ChangeNotifier {
  List<VideoModel> allVideos = [];
  String searchQuery = "";

  Future<void> getAllVideos() async {
    allVideos = await getVideos();
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    notifyListeners();
  }

  List<VideoModel> filteredVideos() {
    if (searchQuery.isEmpty) {
      return allVideos;
    } else {
      return allVideos.where((video) {
        return video.videoTitle.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }
}
