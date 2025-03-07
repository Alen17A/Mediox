import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';

class RecentlyFavouriteVideosProvider extends ChangeNotifier {
  List<VideoModel> recentlyVideos = [];
  List<VideoModel> favouriteVideos = [];

  Future<void> getRecentlyVideosProvider() async {
    recentlyVideos = await getRecentlyVideos();
    notifyListeners();
  }

  Future<void> getFavouritesVideosProvider() async {
    favouriteVideos = await getFavouriteVideos();
    notifyListeners();
  }
}
