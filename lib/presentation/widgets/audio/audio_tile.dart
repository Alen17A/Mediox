import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/audio_playback_test_provider.dart';
import 'package:mediox/presentation/widgets/audio/more_options_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioTile extends StatelessWidget {
  final List<AudioModel> songs;
  final bool showMoreOptions;
  final bool showDelete;
  final String? playlistId;
  final String? category;
  final bool inPlaylist;
  const AudioTile(
      {super.key,
      required this.songs,
      this.showMoreOptions = false,
      this.showDelete = true,
      this.playlistId,
      this.category,
      this.inPlaylist = true});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                await Future.delayed(const Duration(milliseconds: 210));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AudioPlaybackTestProvider(
                              audioFile: songs,
                              index: index,
                              category: category,
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    songs[index].artist,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
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
                                inPlaylist: inPlaylist,
                              ),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              // color: Colors.white12,
            )
          ],
        );
      },
    );
  }
}
