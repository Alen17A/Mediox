import 'package:flutter/material.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
import 'package:mediox/presentation/widgets/video/gridview_videos.dart';
import 'package:provider/provider.dart';

class AllVideos extends StatelessWidget {
  const AllVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GetVideosProvider>(
        builder: (context, getVideosProvider, _) {
      // List<VideoModel> videos = getVideosProvider.allVideos;
      List<VideoModel> videos = getVideosProvider.filteredVideos();
      if (videos.isEmpty) {
        return const Center(
          child: Text("No Videos found"),
        );
      }
      return GridViewVideos(videos: videos);
    });
  }
}
