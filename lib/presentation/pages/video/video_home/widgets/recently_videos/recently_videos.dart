import 'package:flutter/material.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/services/provider/video/recently_favourite_videos.dart';
import 'package:mediox/presentation/widgets/video/gridview_videos.dart';
import 'package:provider/provider.dart';

class RecentlyVideos extends StatelessWidget {
  const RecentlyVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentlyFavouriteVideosProvider>(
        builder: (context, recentlyPlayedVideosProvider, _) {
      if (recentlyPlayedVideosProvider.recentlyVideos.isEmpty) {
        return const Center(child: Text('No recents found.'));
      }
      List<VideoModel> videos = recentlyPlayedVideosProvider.recentlyVideos;
      return GridViewVideos(videos: videos);
    });
  }
}
