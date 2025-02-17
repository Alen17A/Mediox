import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio_model.dart';
import 'package:mediox/screens/audio_playback.dart';
import 'package:mediox/services/provider/mostly_played_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MostlyPlayed extends StatelessWidget {
  const MostlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MostlyPlayedProvider>(
        builder: (context, mostlyProvider, _) {
      if (mostlyProvider.mostlyPlayed.isEmpty) {
        return const Center(child: Text('No favourites'));
      }
      List<AudioModel> songs = mostlyProvider.mostlyPlayed;
      return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          // var song = songs[index];
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AudioPlayback(
              //               audioFile: songs,
              //               index: index,
              //             )));
              print(songs[index].playCount);
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
