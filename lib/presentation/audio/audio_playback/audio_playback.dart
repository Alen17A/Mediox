import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite.dart';
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
  Duration totalDuration = Duration.zero;
  Duration durationPosition = Duration.zero;
  LoopMode currentLoopMode = LoopMode.off;

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
    await Provider.of<RecentlyFavouriteProvider>(context, listen: false)
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
      //   if (state == ProcessingState.completed) {
      //     await skipNext();
      //   }
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
      await Provider.of<RecentlyFavouriteProvider>(context, listen: false)
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
      await Provider.of<RecentlyFavouriteProvider>(context, listen: false)
          .getRecentlySongsProvider();
      setState(() {
        widget.audioFile[currentIndex].playCount++;
      });
      await widget.audioFile[currentIndex].save();
    }
  }

  void repeatAudio() {
    if (currentLoopMode == LoopMode.off) {
      currentLoopMode == LoopMode.one;
    } else if (currentLoopMode == LoopMode.one) {
      currentLoopMode == LoopMode.all;
    } else if (currentLoopMode == LoopMode.all) {
      currentLoopMode = LoopMode.off;
    }

    audioPlayer.setLoopMode(currentLoopMode);
    setState(() {});
  }

  void shuffleAudios() {}

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.audioFile[currentIndex].artist,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              QueryArtworkWidget(
                id: widget.audioFile[currentIndex].audioId,
                type: ArtworkType.AUDIO,
                artworkHeight: 200,
                artworkWidth: 200,
                artworkBorder: BorderRadius.circular(100),
              ),
              const SizedBox(height: 20),
              Text(
                widget.audioFile[currentIndex].title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                maxLines: 1,
                // overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.playlist_add,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 180),
                  IconButton(
                    onPressed: () async {
                      await addSongToPlaylist(
                          playlistAudios: [widget.audioFile[currentIndex]],
                          playlistName: "Favourites",
                          playlistId: "favourite");
                    },
                    icon: const Icon(
                      Icons.favorite_outline,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Slider(
                  thumbColor: const Color(0xff253D2C),
                  activeColor: const Color(0xffCFFFDC),
                  inactiveColor: Colors.black,
                  min: 0,
                  max: totalDuration.inSeconds.toDouble(),
                  value: durationPosition.inSeconds.toDouble(),
                  onChanged: (double value) {
                    final position = Duration(seconds: value.toInt());
                    audioPlayer.seek(position);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(formatDuration(durationPosition)),
                  const SizedBox(
                    width: 150,
                  ),
                  Text(formatDuration(totalDuration)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      repeatAudio();
                    },
                    icon: Icon(
                      currentLoopMode == LoopMode.off
                          ? Icons.repeat
                          : currentLoopMode == LoopMode.one
                              ? Icons.repeat_one
                              : Icons.list,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      skipPrevious();
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      playPause();
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      size: 100,
                      color: const Color.fromARGB(255, 49, 80, 58),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      skipNext();
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shuffle,
                      size: 30,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
