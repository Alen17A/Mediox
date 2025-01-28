import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayback extends StatefulWidget {
  const AudioPlayback({super.key});

  @override
  State<AudioPlayback> createState() => _AudioPlaybackState();
}

class _AudioPlaybackState extends State<AudioPlayback> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  Duration durationPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen to the states: playing, paused and stopped
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 154, 192, 165),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Artist name"),
            const Icon(
              Icons.image,
              size: 200,
            ), //TODO: Add an image
            const Text("audio_name"),
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
                  onPressed: () {},
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
                min: 0,
                max: totalDuration.inSeconds.toDouble(),
                value: durationPosition.inSeconds.toDouble(),
                onChanged: (doubleValue) {}),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(durationPosition.toString()),
                const SizedBox(
                  width: 80,
                ),
                Text(totalDuration.toString()),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.repeat,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.play();
                    }
                  },
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 80,
                    color: Color.fromARGB(255, 49, 80, 58),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_next,
                    size: 30,
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
    );
  }
}
