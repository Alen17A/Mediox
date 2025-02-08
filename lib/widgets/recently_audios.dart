import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio_model.dart';
import 'package:mediox/screens/audio_playback.dart';
import 'package:mediox/services/provider/recently_played.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class RecentlyAudios extends StatelessWidget {
  const RecentlyAudios({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentlyPlayedProvider>(
        builder: (context, recentlyPlayedProvider, _) {
      if (recentlyPlayedProvider.recentlySongs.isEmpty) {
        return const Center(child: Text('No recents found.'));
      }
      List<AudioModel> songs = recentlyPlayedProvider.recentlySongs;
      return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          // var song = songs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AudioPlayback(
                            audioFile: songs,
                            index: index,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  surfaceTintColor: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        QueryArtworkWidget(
                          id: songs[index].audioId,
                          type: ArtworkType.AUDIO,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                songs[index].title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                songs[index].artist,
                                style: const TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        const Icon(Icons.more_vert),
                      ],
                    ),
                  )),
            ),
          );
        },
      );
    });
  }
}
