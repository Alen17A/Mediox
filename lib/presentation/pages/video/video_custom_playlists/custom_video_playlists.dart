import 'package:flutter/material.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/services/provider/video/custom_videos_provider.dart';
import 'package:mediox/presentation/widgets/video/gridview_videos.dart';
import 'package:provider/provider.dart';

class CustomVideos extends StatelessWidget {
  final String playlistName;
  final String playlistId;
  const CustomVideos({super.key, required this.playlistName, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          playlistName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 5,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.blue,
      ),
      body: Consumer<CustomVideosProvider>(
          builder: (context, customVideosProvider, _) {
        if (customVideosProvider.customVideos.isEmpty) {
          return const Center(child: Text('No videos'));
        }
        List<VideoModel> videos = customVideosProvider.customVideos;
        return GridViewVideos(videos: videos, playlistId: playlistId,);
      }),
    );
  }
}
