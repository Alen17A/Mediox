import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

class CustomAudioPlaybackScreen3 extends StatefulWidget {
  final List<AudioModel> audioFiles;
  final int initialIndex;
  const CustomAudioPlaybackScreen3({
    super.key,
    required this.audioFiles,
    required this.initialIndex,
  });

  @override
  _CustomAudioPlaybackScreen3State createState() =>
      _CustomAudioPlaybackScreen3State();
}

class _CustomAudioPlaybackScreen3State
    extends State<CustomAudioPlaybackScreen3> {
  late AudioPlayer _audioPlayer;
  late int _currentIndex;
  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeating = false;
  bool _isFavourite = false;
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  Future<Color?> changeSecondaryColor({required int? audioId}) async {
    if (audioId == null) {
      return Colors.grey;
    } else {
      OnAudioQuery audioQuery = OnAudioQuery();
      Uint8List? bytes = await audioQuery.queryArtwork(
        audioId,
        ArtworkType.AUDIO,
      );
      final MemoryImage imageProvider = MemoryImage(bytes!);
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(imageProvider);

      final List<PaletteColor> validColors =
          paletteGenerator.paletteColors.where((color) {
        return color.color.computeLuminance() > 0.3;
      }).toList();

      if (validColors.isNotEmpty) {
        return validColors.first.color;
      } else {
        return Colors.grey;
      }
    }
  }

  // Future<Uint8List?> fetchArtworkBytes(int audioId) async {
  //   final OnAudioQuery audioQuery = OnAudioQuery();
  //   // This method returns artwork as Uint8List if available.
  //   // (Check the package documentation to ensure the method name and parameters.)
  //   Uint8List? bytes = await audioQuery.queryArtwork(
  //     audioId,
  //     ArtworkType.AUDIO,
  //   );
  //   debugPrint(
  //       "Artwork bytes for $audioId: ${bytes != null ? bytes.length : 'null'}");
  //   return bytes;
  // }

  // Future<Color> getDominantColor(int audioId) async {
  //   Uint8List? artworkBytes = await fetchArtworkBytes(audioId);
  //   if (artworkBytes == null) {
  //     return Colors.grey; // Fallback color if no artwork exists.
  //   }
  //   final PaletteGenerator paletteGenerator =
  //       await PaletteGenerator.fromImageProvider(
  //     MemoryImage(artworkBytes),
  //     size: const Size(200, 200), // Size for analysis; adjust as needed.
  //   );
  //   return paletteGenerator.vibrantColor?.color ?? Colors.grey;
  // }

  // Future<void> _updateBackgroundColor() async {
  //   Color dominantColor =
  //       await getDominantColor(widget.audioFiles[_currentIndex].audioId);
  //   setState(() {
  //     _backgroundColor = dominantColor;
  //   });
  // }

  // You can modify these functions based on your provider logic.
  void _toggleFavourite() {
    setState(() {
      _isFavourite = !_isFavourite;
    });
    // Call your provider function or persist favourite state as needed.
  }

  Future<void> _addToCustomPlaylist() async {
    // Implement adding current song to a custom playlist here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to custom playlist")),
    );
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.initialIndex;
    changeSecondaryColor(audioId: widget.audioFiles[_currentIndex].audioId);
    _initializePlayer();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
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

  Future<void> _toggleShuffle() async {
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
      // backgroundColor: ,
      body: SafeArea(
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
                    onPressed: _toggleFavourite,
                    icon: Icon(
                      _isFavourite ? Icons.favorite : Icons.favorite_border,
                      size: 30,
                      color: _isFavourite ? Colors.red : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _addToCustomPlaylist,
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
                          color: Colors.black87,
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
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(_currentPosition),
                            style: const TextStyle(color: Colors.white)),
                        Text(formatDuration(_totalDuration),
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
    );
  }
}
