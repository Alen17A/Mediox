import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/widgets/queryartwork_bg.dart';
import 'package:mediox/services/provider/audio/audio_playback_controls_provider.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AudioPlayback extends StatefulWidget {
  final List<AudioModel> audioFile;
  final int index;
  const AudioPlayback(
      {required this.audioFile, required this.index, super.key});

  @override
  State<AudioPlayback> createState() => _AudioPlaybackState();
}

class _AudioPlaybackState extends State<AudioPlayback> {
  late AudioPlayer audioPlayer;
  late int currentIndex;
  bool isPlaying = true;
  bool isShuffle = false;
  bool isRepeating = false;
  Duration totalDuration = Duration.zero;
  Duration durationPosition = Duration.zero;

  Future<void> initAudioPlayback() async {
    audioPlayer = AudioPlayer();
    currentIndex = widget.index;
    setAudioSource(widget.audioFile[currentIndex].audioPath);
    audioPlayer.play();
    await addSongToPlaylist(
        playlistAudios: [widget.audioFile[currentIndex]],
        playlistName: "Recently Played",
        playlistId: "recentlyPlayed");
    await Provider.of<RecentlyFavouriteAudiosProvider>(context, listen: false)
        .getRecentlySongsProvider();
    setState(() {
      widget.audioFile[currentIndex].playCount++;
    });
    await widget.audioFile[currentIndex].save();
    await Provider.of<MostlyPlayedProvider>(context, listen: false)
        .getMostlyPlayedProvider();
  }

  Future<void> setAudioSource(String song) async {
    AudioSource source = AudioSource.uri(Uri.parse(song));

    try {
      await audioPlayer.setAudioSource(source);
      totalDuration = (await audioPlayer.load())!;
      audioPlayer.positionStream.listen((position) {
        setState(() {
          durationPosition = position;
          if (durationPosition == totalDuration) {
            skipNext();
          }
        });
      });
    } catch (e) {
      Center(
        child: Text("Error setting audio: $e"),
      );
    }
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> skipNext() async {
    if (currentIndex < widget.audioFile.length - 1) {
      setState(() {
        currentIndex++;
      });
      setAudioSource(widget.audioFile[currentIndex].audioPath);
      await audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
      await addSongToPlaylist(
          playlistAudios: [widget.audioFile[currentIndex]],
          playlistName: "Recently Played",
          playlistId: "recentlyPlayed");
      await Provider.of<RecentlyFavouriteAudiosProvider>(context, listen: false)
          .getRecentlySongsProvider();
      setState(() {
        widget.audioFile[currentIndex].playCount++;
      });
      await widget.audioFile[currentIndex].save();
    }
  }

  Future<void> skipPrevious() async {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      setAudioSource(widget.audioFile[currentIndex].audioPath);
      audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
      await addSongToPlaylist(
          playlistAudios: [widget.audioFile[currentIndex]],
          playlistName: "Recently Played",
          playlistId: "recentlyPlayed");
      await Provider.of<RecentlyFavouriteAudiosProvider>(context, listen: false)
          .getRecentlySongsProvider();
      setState(() {
        widget.audioFile[currentIndex].playCount++;
      });
      await widget.audioFile[currentIndex].save();
    }
  }

  void toggleRepeat() {
    setState(() {
      isRepeating = !isRepeating;
    });
    audioPlayer.setLoopMode(isRepeating ? LoopMode.one : LoopMode.off);
  }

  Future<void> shuffleAudios() async {
    setState(() {
      isShuffle = !isShuffle;
    });
    await audioPlayer.setShuffleModeEnabled(isShuffle);
    if (isShuffle) {
      await audioPlayer.shuffle();
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.audioFile[currentIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Blurred artwork image
          QueryArtWorkBackground(audioId: currentSong.audioId),
          // Apply a blur effect over the background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: const Color.fromARGB(98, 0, 0, 0),
            ),
          ),
          // Main content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Top row: Favourites & Custom Playlist Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<RecentlyFavouriteAudiosProvider>(
                        builder: (context, isFavouriteProvider, _) {
                          bool isFav = isFavouriteProvider
                              .isFavourite(currentSong.audioId);
                          return IconButton(
                            onPressed: () {
                              isFavouriteProvider.toggleFavourites(currentSong);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isFav
                                      ? "Removed from favourites"
                                      : "Added to favourites"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 30,
                              color: isFav ? Colors.red : Colors.white,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.playlist_add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Center: Album artwork, artist, and title
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 63, 62, 62),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: QueryArtworkWidget(
                          id: currentSong.audioId,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 250,
                          artworkWidth: 250,
                          artworkBorder: BorderRadius.circular(125),
                          nullArtworkWidget: Container(
                            width: 250,
                            height: 250,
                            decoration: const BoxDecoration(
                              // color: Colors.grey,
                              gradient: LinearGradient(colors: [
                                Colors.green,
                                Color.fromARGB(255, 20, 101, 22)
                              ]),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.music_note,
                                size: 100, color: Colors.white),
                          ),
                          keepOldArtwork: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        currentSong.artist,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentSong.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // Playback slider and durations
                  // Playback slider and durations
                  Consumer<AudioPlaybackControlsProvider>(
                    builder: (context, audioPlaybackControls, _) {
                      return Column(
                        children: [
                          Slider(
                            thumbColor: const Color(0xff253D2C),
                            activeColor: Colors.white,
                            inactiveColor:
                                const Color.fromARGB(255, 80, 80, 80),
                            min: 0,
                            max: audioPlaybackControls.totalDuration.inSeconds > 0
                                ? audioPlaybackControls.totalDuration.inSeconds
                                    .toDouble()
                                : 1.0,
                            value: audioPlaybackControls
                                .durationPosition.inSeconds
                                .toDouble()
                                .clamp(
                                    0.0,
                                    audioPlaybackControls
                                        .totalDuration.inSeconds
                                        .toDouble()),
                            onChanged: (value) {
                              final newPosition =
                                  Duration(seconds: value.toInt());
                              audioPlaybackControls.audioPlayer.seek(newPosition);
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    formatDuration(
                                        audioPlaybackControls.durationPosition),
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    formatDuration(
                                        audioPlaybackControls.totalDuration),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Playback controls row
                  Consumer<AudioPlaybackControlsProvider>(
                    builder: (context, audioPlaybackControls, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: toggleRepeat,
                            icon: Icon(
                              audioPlaybackControls.isRepeating
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                              size: 30,
                              color: audioPlaybackControls.isRepeating
                                  ? Colors.green
                                  : Colors.white70,
                            ),
                          ),
                          IconButton(
                            onPressed: skipPrevious,
                            icon: const Icon(Icons.skip_previous,
                                size: 40, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: playPause,
                            icon: Icon(
                              audioPlaybackControls.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: skipNext,
                            icon: const Icon(Icons.skip_next,
                                size: 40, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: shuffleAudios,
                            icon: Icon(
                              Icons.shuffle,
                              size: 30,
                              color: audioPlaybackControls.isShuffle
                                  ? Colors.green
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
