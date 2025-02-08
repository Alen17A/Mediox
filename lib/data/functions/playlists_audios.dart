import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/models/audio_model.dart';
import 'package:mediox/data/models/audios_playlist_model.dart';

late LazyBox<AudioPlaylistModel> playlistModelAudioBox;

// Add to playlist
Future<void> addSongToPlaylist(
    {String? playlistId,
    required List<AudioModel> playlistAudios,
    required String playlistName}) async {
  if (playlistId == null) {
    playlistId ??= DateTime.now().microsecondsSinceEpoch.toString();
    AudioPlaylistModel playlistModel = AudioPlaylistModel(
        playlistId: playlistId,
        playlistName: playlistName,
        playlistAudios: playlistAudios);

    await playlistModelAudioBox.put(playlistId, playlistModel);
  } else {
    AudioPlaylistModel? audioPlaylistModel =
        await playlistModelAudioBox.get(playlistId);

    if (audioPlaylistModel != null) {
      for (AudioModel playlistAudio in playlistAudios) {
        audioPlaylistModel.playlistAudios.removeWhere(
            (playlistSong) => playlistSong.audioId == playlistAudio.audioId);
      }

      AudioPlaylistModel playlistModel = AudioPlaylistModel(
          playlistId: playlistId,
          playlistName: playlistName,
          playlistAudios: [
            ...playlistAudios,
            ...audioPlaylistModel.playlistAudios
          ]);

      await playlistModelAudioBox.put(playlistId, playlistModel);
    } else {
      AudioPlaylistModel playlistModel = AudioPlaylistModel(
          playlistId: playlistId,
          playlistName: playlistName,
          playlistAudios: playlistAudios);

      await playlistModelAudioBox.put(playlistId, playlistModel);
    }
  }
}

// Get songs
Future<List<AudioModel>> getRecentlySongs() async {
  List<AudioModel> recentlyAudios = [];
  final AudioPlaylistModel? recentlyPlayed =
      await playlistModelAudioBox.get("recentlyPlayed");
  if (recentlyPlayed != null) {
    recentlyAudios.addAll(recentlyPlayed.playlistAudios);
  }

  return recentlyAudios;
}
