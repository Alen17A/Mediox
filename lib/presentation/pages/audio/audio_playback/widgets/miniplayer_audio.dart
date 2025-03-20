import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/audio_playback_test_provider.dart';
import 'package:mediox/services/provider/audio/audio_playback_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MiniplayerAudio extends StatelessWidget {
  const MiniplayerAudio({super.key});

  @override
  Widget build(BuildContext context) {
    final playbackProvider = Provider.of<AudioPlaybackProvider>(context);

    // Hide mini-player if no audio is active
    if (playbackProvider.currentAudioPath == null) {
      return const SizedBox.shrink();
    }

    final currentSong =
        playbackProvider.audioFiles[playbackProvider.currentIndex];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 10, right: 10),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 161, 212, 163).withAlpha(127),
                const Color.fromARGB(255, 22, 149, 26).withAlpha(127)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Album Artwork (Placeholder or actual)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: QueryArtworkWidget(
                    id: currentSong.audioId,
                    type: ArtworkType.AUDIO,
                    artworkHeight: 50,
                    artworkWidth: 50,
                    artworkBorder: BorderRadius.circular(125),
                    nullArtworkWidget: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.green,
                          Color.fromARGB(255, 20, 101, 22)
                        ]),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.music_note,
                          size: 30, color: Colors.white),
                    ),
                    keepOldArtwork: true,
                  ),
                ),
              ),
                
              // Song Info
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioPlaybackTestProvider(
                          audioFile: playbackProvider.audioFiles,
                          index: playbackProvider.currentIndex,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentSong.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currentSong.artist,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                
              // Playback Controls
              IconButton(
                onPressed: () async {
                  playbackProvider.skipPrevious();
                  await Provider.of<RecentlyFavouriteAudiosProvider>(
                          context,
                          listen: false)
                      .getRecentlySongsProvider();
                },
                icon: const Icon(Icons.skip_previous,
                    size: 32, color: Colors.white),
                splashRadius: 25,
              ),
              IconButton(
                onPressed: playbackProvider.playPause,
                icon: Icon(
                  playbackProvider.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 38,
                  color: Colors.white,
                ),
                splashRadius: 30,
              ),
              IconButton(
                onPressed: () async {
                  playbackProvider.skipNext();
                  await Provider.of<RecentlyFavouriteAudiosProvider>(
                          context,
                          listen: false)
                      .getRecentlySongsProvider();
                },
                icon: const Icon(Icons.skip_next,
                    size: 32, color: Colors.white),
                splashRadius: 25,
              ),
                
              // Close Button (NEW)
              IconButton(
                onPressed: () {
                  playbackProvider
                      .stopPlayback(); // Stop playback & hide mini player
                },
                icon:
                    const Icon(Icons.close, size: 28, color: Colors.white),
                splashRadius: 20,
              ),
                
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
