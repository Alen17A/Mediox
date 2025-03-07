import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/video/video_custom_playlists/custom_video_playlists.dart';
import 'package:mediox/presentation/pages/video/video_favourites/favourites_video.dart';
import 'package:mediox/services/provider/video/custom_playlists_videos_provider.dart';
import 'package:mediox/services/provider/video/custom_videos_provider.dart';
import 'package:provider/provider.dart';

class AllPlaylistsVideos extends StatelessWidget {
  const AllPlaylistsVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                overlayColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 197, 120, 115)),
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavouritesVideo()));
                },
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.grey,
                  surfaceTintColor: Colors.red,
                  child: ListTile(
                    leading: Icon(
                      Icons.favorite_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Favourites",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Consumer<CustomPlaylistsVideosProvider>(
                  builder: (context, customPlaylistVideosProvider, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Provider.of<CustomVideosProvider>(context,
                                listen: false)
                            .getCustomVideosProvider(customPlaylistVideosProvider
                                .customPlaylistsVideos[index].playlistId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomVideos(
                                    playlistName: customPlaylistVideosProvider
                                        .customPlaylistsVideos[index].playlistName, playlistId: customPlaylistVideosProvider.customPlaylistsVideos[index].playlistId,)));
                      },
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.grey,
                        surfaceTintColor: Colors.blue,
                        child: ListTile(
                          title: Text(
                            customPlaylistVideosProvider
                                .customPlaylistsVideos[index].playlistName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: customPlaylistVideosProvider.customPlaylistsVideos.length,
                  shrinkWrap: true,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}