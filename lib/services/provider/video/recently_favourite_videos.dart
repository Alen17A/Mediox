import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';

class RecentlyFavouriteVideosProvider extends ChangeNotifier {
  List<VideoModel> recentlyVideos = [];
  List<VideoModel> favouriteVideos = [];
  String searchQuery = "";

  Future<void> getRecentlyVideosProvider() async {
    recentlyVideos = await getRecentlyVideos();
    notifyListeners();
  }

  Future<void> getFavouritesVideosProvider() async {
    favouriteVideos = await getFavouriteVideos();
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    notifyListeners();
  }

  List<VideoModel> filteredVideosRecents() {
    if (searchQuery.isEmpty) {
      return recentlyVideos;
    } else {
      return recentlyVideos.where((video) {
        return video.videoTitle
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  List<VideoModel> filteredVideoFavorites() {
    if (searchQuery.isEmpty) {
      return favouriteVideos;
    } else {
      return favouriteVideos.where((video) {
        return video.videoTitle
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  bool isFavourite(String videoId) {
    return favouriteVideos.any((video) => video.videoId == videoId);
  }

  void toggleFavourites(VideoModel video) {
    if (isFavourite(video.videoId)) {
      favouriteVideos.removeWhere((item) => item.videoId == video.videoId);
    } else {
      favouriteVideos.add(video);
    }
    notifyListeners();
  }
}
