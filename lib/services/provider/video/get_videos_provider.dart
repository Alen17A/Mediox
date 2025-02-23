import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/store_fetch_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';

class GetVideosProvider extends ChangeNotifier {
  List<VideoModel> allVideos = [];

  Future<void> getAllVideos() async {
    allVideos = await getVideos();
    notifyListeners();
  }
}
