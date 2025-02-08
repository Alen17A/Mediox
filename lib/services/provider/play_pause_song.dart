import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayPauseSong extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  List<String> _playlist = [];

  AudioPlayer get audioplayer => _audioPlayer;
  int get currentIndex => _currentIndex;
  List<String> get playlist => _playlist;

  void setPlaylist(List<String> playlist) {
    _playlist = playlist;
    if (_playlist.isNotEmpty) {
      _setAudioSource(_playlist[_currentIndex]);
    }
    notifyListeners();
  }

  Future<void> _setAudioSource(String path) async {
    await audioplayer.setFilePath(path);
  }

  void playSong() {
    _audioPlayer.play();
    notifyListeners();
  }

  void pauseSong() {
    _audioPlayer.pause();
    notifyListeners();
  }

  void skipNext() {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      _setAudioSource(_playlist[_currentIndex]);
      playSong();
    }
    notifyListeners();
  }

  void skipPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _setAudioSource(_playlist[_currentIndex]);
      playSong();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
