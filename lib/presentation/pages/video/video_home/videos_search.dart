import 'package:flutter/material.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
import 'package:provider/provider.dart';

class VideosSearch extends StatelessWidget {
  const VideosSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<GetVideosProvider>(context);
    return SearchBar(
      leading: const Icon(Icons.search),
      hintText: "Search Videos....",
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      shadowColor: WidgetStatePropertyAll(Colors.blue[300]),
      onChanged: (query) {
        videoProvider.search(query);
      },
    );
  }
}
