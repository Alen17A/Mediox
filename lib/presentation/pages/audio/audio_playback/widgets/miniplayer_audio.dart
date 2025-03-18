import 'package:flutter/material.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/audio_playback_test_provider.dart';
import 'package:mediox/services/provider/audio/audio_playback_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.purple,
                Colors.blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
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
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.music_note,
                        color: Colors.white, size: 30),
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
