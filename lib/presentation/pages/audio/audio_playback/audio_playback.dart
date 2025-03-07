import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/widgets/queryartwork_bg.dart';
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
  bool isFavourite = false;
  bool isShuffle = false;
  bool isRepeating = false;
  Duration totalDuration = Duration.zero;
  Duration durationPosition = Duration.zero;

  @override
  void initState() {
    initAudioPlayback();
    super.initState();
  }

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
      // audioPlayer.processingStateStream.listen((state) async {
      //   // if (state == ProcessingState.completed) {
      //   //   if (currentLoopMode == LoopMode.one) {
      //   //     // If repeating one, seek to the beginning and play again.
      //   //     audioPlayer.seek(Duration.zero);
      //   //     audioPlayer.play();
      //   //   } else {
      //   //     skipNext();
      //   //   }
      //   // }
      // });
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

  void toggleFavourite() async {
    // setState(() {
    //   isFavourite = !isFavourite;
    // });
    await addSongToPlaylist(
            playlistAudios: [widget.audioFile[currentIndex]],
            playlistName: "Favourites",
            playlistId: "favourite")
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Added to favourites"),
        backgroundColor: Colors.green,
      ));
    });
    await Provider.of<RecentlyFavouriteAudiosProvider>(context, listen: false)
        .getFavouritesProvider();
    setState(() {
      isFavourite = true;
    });
    // Call your provider function or persist favourite state as needed.
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
                      IconButton(
                        onPressed: toggleFavourite,
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          size: 30,
                          color: isFavourite ? Colors.red : Colors.white,
                        ),
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
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.music_note,
                                size: 100, color: Colors.white),
                          ),
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
                  Column(
                    children: [
                      Slider(
                        thumbColor: const Color(0xff253D2C),
                        activeColor: Colors.greenAccent,
                        inactiveColor: Colors.white38,
                        min: 0,
                        max: totalDuration.inSeconds > 0
                            ? totalDuration.inSeconds.toDouble()
                            : 1.0,
                        value: durationPosition.inSeconds
                            .toDouble()
                            .clamp(0.0, totalDuration.inSeconds.toDouble()),
                        onChanged: (value) {
                          final newPosition = Duration(seconds: value.toInt());
                          audioPlayer.seek(newPosition);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(durationPosition),
                                style: const TextStyle(color: Colors.white)),
                            Text(formatDuration(totalDuration),
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Playback controls row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: toggleRepeat,
                        icon: Icon(
                          isRepeating ? Icons.repeat_one : Icons.repeat,
                          size: 30,
                          color: isRepeating ? Colors.green : Colors.white70,
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
                          isPlaying
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
                          color: isShuffle ? Colors.green : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
