import 'package:flutter/material.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/services/provider/video/mostly_videos_provider.dart';
import 'package:mediox/presentation/widgets/video/gridview_videos.dart';
import 'package:provider/provider.dart';

class MostlyVideos extends StatelessWidget {
  const MostlyVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MostlyVideosProvider>(
        builder: (context, mostlyVideosProvider, _) {
      if (mostlyVideosProvider.mostlyPlayedVideos.isEmpty) {
        return const Center(child: Text('No videos'));
      }
      List<VideoModel> videos = mostlyVideosProvider.mostlyPlayedVideos;
      return GridViewVideos(videos: videos);
    });
  }
}
