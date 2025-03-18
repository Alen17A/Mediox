import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class AudioPlaybackProvider extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  late List<AudioModel> audioFiles;
  late int currentIndex;
  bool isPlaying = false;
  bool isShuffle = false;
  bool isRepeating = false;
  Duration totalDuration = Duration.zero;
  Duration durationPosition = Duration.zero;
  String? currentAudioPath;

  AudioPlaybackProvider() {
    // Sync isPlaying with the player's actual state
    audioPlayer.playingStream.listen((playing) {
      isPlaying = playing;
      notifyListeners();
    });
  }

  Future<void> initAudioPlayback(
      {required List<AudioModel> audioFile, required int index}) async {
    audioFiles = audioFile;
    currentIndex = index;

    await audioPlayer.stop();
    await audioPlayer.seek(Duration.zero);

    try {
      await setAudioSource(audioFile[index].audioPath);
      await audioPlayer.play();
      currentAudioPath = audioFile[index].audioPath; // Track current song

      // Update playlist and play count
      await addSongToPlaylist(
        playlistAudios: [audioFile[index]],
        playlistName: "Recently Played",
        playlistId: "recentlyPlayed",
      );
      audioFile[index].playCount++;
      await audioFile[index].save();
    } catch (e) {
      debugPrint("Error in initAudioPlayback: $e");
      isPlaying = false;
    }

    notifyListeners();
  }

  Future<void> setAudioSource(String song) async {
    AudioSource source = AudioSource.uri(Uri.parse(song));

    try {
      await audioPlayer.setAudioSource(source);
      totalDuration = (await audioPlayer.load())!;
      await audioPlayer.seek(Duration.zero);

      audioPlayer.positionStream.listen((position) {
        durationPosition = position;
        if (durationPosition >= totalDuration &&
            totalDuration > Duration.zero) {
          skipNext();
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error setting audio: $e");
    }
  }

  void playPause() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }

    notifyListeners();
  }

  // Future<void> skipNext() async {
  //   if (currentIndex < audioFiles.length - 1) {
  //     currentIndex++;
  //     await initAudioPlayback(audioFile: audioFiles, index: currentIndex);
  //   }else {
  //   await audioPlayer.stop();
  //   currentAudioPath = null;
  //   notifyListeners(); // Hides the mini-player
  // }
  // }
  Future<void> skipNext() async {
    await playNextSong();
  }

  Future<void> skipPrevious() async {
    if (currentIndex > 0) {
      currentIndex--;
      await initAudioPlayback(audioFile: audioFiles, index: currentIndex);
    }
  }

  Future<void> playNextSong() async {
    if (audioFiles.isEmpty) return;

    int newIndex = currentIndex;
    if (isShuffle) {
      do {
        newIndex = Random().nextInt(audioFiles.length);
      } while (newIndex == currentIndex && audioFiles.length > 1);
    } else if (newIndex < audioFiles.length - 1) {
      newIndex++;
    } else if (isRepeating) {
      newIndex = 0;
    } else {
      await audioPlayer.stop();
      currentAudioPath = null;
      isPlaying = false;
      notifyListeners();
      return;
    }

    currentIndex = newIndex;

    try {
      await setAudioSource(audioFiles[currentIndex].audioPath);
      await audioPlayer.play();
      isPlaying = true;
      currentAudioPath = audioFiles[currentIndex].audioPath;

      await addSongToPlaylist(
        playlistAudios: [audioFiles[currentIndex]],
        playlistName: "Recently Played",
        playlistId: "recentlyPlayed",
      );
      audioFiles[currentIndex].playCount++;
      await audioFiles[currentIndex].save();
    } catch (e) {
      debugPrint("Error in playNextSong: $e");
      isPlaying = false;
    }

    notifyListeners();
  }

  void toggleRepeat() {
    isRepeating = !isRepeating;
    audioPlayer.setLoopMode(isRepeating ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  Future<void> shuffleAudios() async {
    isShuffle = !isShuffle;
    notifyListeners();
  }

  void stopPlayback() async {
    await audioPlayer.stop();
    isPlaying = false; // Stop the audio
    currentAudioPath = null; // Hide mini-player
    notifyListeners();
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Dispose of the AudioPlayer when provider is destroyed
    super.dispose();
  }
}
