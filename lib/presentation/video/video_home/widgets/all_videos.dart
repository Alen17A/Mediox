import 'package:flutter/material.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/presentation/video/video_playback/video_playback.dart';
import 'package:mediox/services/provider/video/get_videos_provider.dart';
import 'package:provider/provider.dart';

class AllVideos extends StatelessWidget {
  const AllVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GetVideosProvider>(
        builder: (context, getVideosProvider, _) {
      List<VideoModel> videos = getVideosProvider.allVideos;
      if (videos.isEmpty) {
        return const Center(
          child: Text("No Videos found"),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayback(playbackVideos: videos, videoIndex: index,)));
            },
            child: Card(
                elevation: 5,
                shadowColor: Colors.grey,
                surfaceTintColor: Colors.blue[300],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          videos[index].thumbnail != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: MemoryImage(
                                            videos[index].thumbnail!,
                                          ),
                                          fit: BoxFit.cover)),
                                  width: double.infinity,
                                  height: 120,
                                )
                              : const Icon(Icons.image),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoPlayback(
                                              playbackVideos: videos,
                                              videoIndex: index,
                                            )));
                              },
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                size: 50,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      Text(
                        videos[index].videoTitle,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )),
          );
        },
        itemCount: videos.length,
      );
    });
  }
}
