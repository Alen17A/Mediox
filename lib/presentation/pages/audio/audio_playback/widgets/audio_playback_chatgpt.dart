import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomAudioPlaybackScreen extends StatefulWidget {
  final List<AudioModel> audioFiles;
  final int initialIndex;
  const CustomAudioPlaybackScreen({
    super.key,
    required this.audioFiles,
    required this.initialIndex,
  });

  @override
  State<CustomAudioPlaybackScreen> createState() =>
      _CustomAudioPlaybackScreenState();
}

class _CustomAudioPlaybackScreenState extends State<CustomAudioPlaybackScreen> {
  late AudioPlayer _audioPlayer;
  late int _currentIndex;
  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeating = false;
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _initializePlayer();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // When track ends, check repeat or skip next
        if (_isRepeating) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
        } else {
          _skipNext();
        }
      }
    });
  }

  Future<void> _initializePlayer() async {
    try {
      final currentSong = widget.audioFiles[_currentIndex];
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(currentSong.audioPath)),
      );
      _totalDuration = _audioPlayer.duration ?? Duration.zero;
      setState(() {});
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      debugPrint("Error initializing audio: $e");
    }
  }

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _skipNext() async {
    if (_currentIndex < widget.audioFiles.length - 1) {
      setState(() {
        _currentIndex++;
      });
      await _initializePlayer();
    } else {
      // Optionally loop or stop if at the end
      debugPrint("End of playlist");
    }
  }

  Future<void> _skipPrevious() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      await _initializePlayer();
    }
  }

  void _toggleShuffle() async {
    setState(() {
      _isShuffle = !_isShuffle;
    });
    await _audioPlayer.setShuffleModeEnabled(_isShuffle);
    if (_isShuffle) {
      await _audioPlayer.shuffle();
    }
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeating = !_isRepeating;
    });
    // Set repeat mode on the audio player accordingly:
    _audioPlayer.setLoopMode(_isRepeating ? LoopMode.one : LoopMode.off);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.audioFiles[_currentIndex];
    return Scaffold(
      // Gradient background for modern look
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Song artist
                Text(
                  currentSong.artist,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                // Album artwork in a circular container with shadow
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15,
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
                // Song title
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
                // Playback slider
                Column(
                  children: [
                    Slider(
                      thumbColor: const Color(0xff253D2C),
                      activeColor: Colors.greenAccent,
                      inactiveColor: Colors.white38,
                      min: 0,
                      max: _totalDuration.inSeconds > 0
                          ? _totalDuration.inSeconds.toDouble()
                          : 1.0,
                      value: _currentPosition.inSeconds
                          .toDouble()
                          .clamp(0.0, _totalDuration.inSeconds.toDouble()),
                      onChanged: (value) {
                        final newPosition = Duration(seconds: value.toInt());
                        _audioPlayer.seek(newPosition);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(_currentPosition),
                            style: const TextStyle(color: Colors.white)),
                        Text(formatDuration(_totalDuration),
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                // Playback controls row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _toggleRepeat,
                      icon: Icon(
                        _isRepeating ? Icons.repeat_one : Icons.repeat,
                        size: 30,
                        color: _isRepeating ? Colors.green : Colors.white70,
                      ),
                    ),
                    IconButton(
                      onPressed: _skipPrevious,
                      icon: const Icon(Icons.skip_previous,
                          size: 40, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: _playPause,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: _skipNext,
                      icon: const Icon(Icons.skip_next,
                          size: 40, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: _toggleShuffle,
                      icon: Icon(
                        Icons.shuffle,
                        size: 30,
                        color: _isShuffle ? Colors.green : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
