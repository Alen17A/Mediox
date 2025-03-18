import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/audio_playback.dart';
import 'package:mediox/presentation/widgets/audio/more_options_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioTileCard extends StatelessWidget {
  final List<AudioModel> songs;
  final bool showMoreOptions;
  final bool showDelete;
  final String? playlistId;
  const AudioTileCard({
    super.key,
    required this.songs,
    this.showMoreOptions = false,
    this.showDelete = true,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AudioPlayback(
                          audioFile: songs,
                          index: index,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              // color: const Color.fromARGB(255, 63, 63, 63),
                elevation: 5,
                shadowColor: Colors.grey,
                surfaceTintColor: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      QueryArtworkWidget(
                        id: songs[index].audioId,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 160, 199, 171)),
                          child: const Icon(Icons.music_note),
                        ),
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
                      if (showMoreOptions)
                        MoreOptionsAudio(
                          songs: songs,
                          playlistId: playlistId,
                          index: index,
                          showDelete: showDelete,
                        ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
