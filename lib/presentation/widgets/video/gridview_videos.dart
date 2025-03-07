import 'package:flutter/material.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/presentation/pages/video/video_playback/video_playback.dart';
import 'package:mediox/presentation/widgets/video/more_options_video.dart';

class GridViewVideos extends StatelessWidget {
  final List<VideoModel> videos;
  final String? playlistId;
  const GridViewVideos({super.key, required this.videos, this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
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
                      Expanded(
                        child: Stack(
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              videos[index].videoTitle,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          MoreOptionsVideo(videos: videos, index: index, playlistId: playlistId,),
                        ],
                      )
                    ],
                  ),
                )),
          );
        },
        itemCount: videos.length,
      );
  }
}
