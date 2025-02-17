import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/models/audio_model.dart';
import 'package:mediox/data/models/audios_playlist_model.dart';

late LazyBox<AudioPlaylistModel> playlistModelAudioBox;

// Add to playlist (Recents, favourites and custom)
Future<void> addSongToPlaylist(
    {String? playlistId,
    required List<AudioModel> playlistAudios,
    required String playlistName}) async {
  if (playlistId == null) {    //For custom playlists when creating for first time
    playlistId ??= DateTime.now().microsecondsSinceEpoch.toString();
    AudioPlaylistModel playlistModel = AudioPlaylistModel(
        playlistId: playlistId,
        playlistName: playlistName,
        playlistAudios: playlistAudios);

    await playlistModelAudioBox.put(playlistId, playlistModel);
  } else {
    AudioPlaylistModel? audioPlaylistModel = 
        await playlistModelAudioBox.get(playlistId);  //If a playlist already exists, get its id.

    if (audioPlaylistModel != null) {  //If the audioPlaylistModel already contains some audios,
      for (AudioModel playlistAudio in playlistAudios) {  //playlistAudios = Audios of the playlist that is get.
        audioPlaylistModel.playlistAudios.removeWhere(  //remove audio from audioPlaylistModel if playlistAudios contains the same audio.
            (playlistSong) => playlistSong.audioId == playlistAudio.audioId);
      }

      AudioPlaylistModel playlistModel = AudioPlaylistModel( //Add audios of audioPlaylistModel and that playlist which is get.
          playlistId: playlistId,
          playlistName: playlistName,
          playlistAudios: [
            ...playlistAudios,
            ...audioPlaylistModel.playlistAudios
          ]);

      await playlistModelAudioBox.put(playlistId, playlistModel);
    } else {
      AudioPlaylistModel playlistModel = AudioPlaylistModel( //If audioPlaylistModel is empty.
          playlistId: playlistId,
          playlistName: playlistName,
          playlistAudios: playlistAudios);

      await playlistModelAudioBox.put(playlistId, playlistModel);
    }
  }
}

// Get recently played audios
Future<List<AudioModel>> getRecentlySongs() async { //Get the audios to a list.
  List<AudioModel> recentlyAudios = [];
  final AudioPlaylistModel? recentlyPlayed =
      await playlistModelAudioBox.get("recentlyPlayed");
  if (recentlyPlayed != null) {
    recentlyAudios.addAll(recentlyPlayed.playlistAudios);
  }

  return recentlyAudios.take(10).toList();
}

// Get favourite audios
Future<List<AudioModel>> getFavouriteAudios() async {
  //Get the audios to a list.
  List<AudioModel> favouriteAudios = [];
  final AudioPlaylistModel? favourites =
      await playlistModelAudioBox.get("favourite");
  if (favourites != null) {
    favouriteAudios.addAll(favourites.playlistAudios);
  }

  return favouriteAudios;
}
