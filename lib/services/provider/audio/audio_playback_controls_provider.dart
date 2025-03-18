import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class AudioPlaybackControlsProvider extends ChangeNotifier{
  final AudioPlayer audioPlayer = AudioPlayer();
  late List<AudioModel> audioFiles;
  late int currentIndex;
  bool isPlaying = false;
  bool isShuffle = false;
  bool isRepeating = false;
  Duration totalDuration = Duration.zero;
  Duration durationPosition = Duration.zero;
  String? currentAudioPath;
}