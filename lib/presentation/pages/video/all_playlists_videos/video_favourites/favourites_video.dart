import 'package:flutter/material.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/services/provider/video/recently_favourite_videos.dart';
import 'package:mediox/presentation/widgets/video/gridview_videos.dart';
import 'package:provider/provider.dart';

class FavouritesVideo extends StatelessWidget {
  const FavouritesVideo({super.key});

  @override
  Widget build(BuildContext context) {
    const String category = "Favourites";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
        elevation: 5,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.red,
      ),
      body: Consumer<RecentlyFavouriteVideosProvider>(
          builder: (context, favouritesVideoProvider, _) {
        if (favouritesVideoProvider.favouriteVideos.isEmpty) {
          return const Center(child: Text('No favourites'));
        }
        List<VideoModel> videos = favouritesVideoProvider.favouriteVideos;
        return GridViewVideos(videos: videos, playlistId: "favourite", showMoreOptions: true, inPlaylist: false, category: category,);
      }),
    );
  }
}
