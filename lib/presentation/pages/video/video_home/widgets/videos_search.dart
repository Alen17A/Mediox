import 'package:flutter/material.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
import 'package:mediox/services/provider/video/mostly_videos_provider.dart';
import 'package:mediox/services/provider/video/recently_favourite_videos.dart';
import 'package:provider/provider.dart';

class VideosSearch extends StatelessWidget {
  const VideosSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final allVideoProvider = Provider.of<GetVideosProvider>(context);
    final recentVideoProvider =
        Provider.of<RecentlyFavouriteVideosProvider>(context);
    final mostlyVideoProvider = Provider.of<MostlyVideosProvider>(context);
    final favoriteVideoProvider =
        Provider.of<RecentlyFavouriteVideosProvider>(context);

    return SearchBar(
      leading: const Icon(Icons.search),
      hintText: "Search Videos....",
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      shadowColor: WidgetStatePropertyAll(Colors.blue[300]),
      onChanged: (query) {
        allVideoProvider.search(query);
        recentVideoProvider.search(query);
        mostlyVideoProvider.search(query);
        favoriteVideoProvider.search(query);
      },
    );
  }
}
