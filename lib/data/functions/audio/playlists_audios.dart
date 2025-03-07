import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/data/models/audio/audios_playlist_model.dart';

late LazyBox<AudioPlaylistModel> playlistModelAudioBox;

// Add to playlist (Recents, favourites and custom)
Future<void> addSongToPlaylist(
    {String? playlistId,
    required List<AudioModel> playlistAudios,
    String? playlistName}) async {
  if (playlistId == null) {
    //For custom playlists when creating for first time
    playlistId ??= DateTime.now().microsecondsSinceEpoch.toString();
    AudioPlaylistModel playlistModel = AudioPlaylistModel(
        playlistId: playlistId,
        playlistName: playlistName!,
        playlistAudios: playlistAudios);

    await playlistModelAudioBox.put(playlistId, playlistModel);
  } else {
    AudioPlaylistModel? audioPlaylistModel = await playlistModelAudioBox
        .get(playlistId); //If a playlist already exists, get its id.

    if (audioPlaylistModel != null) {
      //If the audioPlaylistModel already contains some audios,
      for (AudioModel playlistAudio in playlistAudios) {
        //playlistAudios = Audios of the playlist that is get.
        audioPlaylistModel.playlistAudios.removeWhere(
            //remove audio from audioPlaylistModel if playlistAudios contains the same audio.
            (playlistSong) => playlistSong.audioId == playlistAudio.audioId);
      }

      List<AudioModel> temp = List.from(audioPlaylistModel.playlistAudios);
      audioPlaylistModel.playlistAudios.clear();

      audioPlaylistModel.playlistAudios.addAll(temp + playlistAudios);

      await playlistModelAudioBox.put(playlistId, audioPlaylistModel);
    } else {
      AudioPlaylistModel playlistModel = AudioPlaylistModel(
          //If audioPlaylistModel is empty.
          playlistId: playlistId,
          playlistName: playlistName!,
          playlistAudios: playlistAudios);

      await playlistModelAudioBox.put(playlistId, playlistModel);
    }
  }
}

// Get recently played audios
Future<List<AudioModel>> getRecentlySongs() async {
  //Get the audios to a list.
  List<AudioModel> recentlyAudios = [];
  final AudioPlaylistModel? recentlyPlayed =
      await playlistModelAudioBox.get("recentlyPlayed");
  if (recentlyPlayed != null) {
    recentlyAudios.addAll(recentlyPlayed.playlistAudios);
  }

  return recentlyAudios;
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

// Get audios of each playlists
Future<List<AudioModel>> getCustomAudios(String playlistId) async {
  //Get the audios to a list.
  List<AudioModel> customAudios = [];
  final AudioPlaylistModel? customAudio =
      await playlistModelAudioBox.get(playlistId);
  if (customAudio != null) {
    customAudios.addAll(customAudio.playlistAudios);
  }

  return customAudios;
}

// Get custom playlists
Future<List<AudioPlaylistModel>> getPlaylists() async {
  //Get playlists to a list.
  List<AudioPlaylistModel> playlists = [];
  for (String key in playlistModelAudioBox.keys) {
    AudioPlaylistModel? audioPlaylist = await playlistModelAudioBox.get(key);
    if (audioPlaylist != null) {
      playlists.add(audioPlaylist);
    }
  }

  playlists.removeWhere((AudioPlaylistModel playlist) =>
      playlist.playlistId == "recentlyPlayed" ||
      playlist.playlistId == "favourite");
  return playlists;
}

Future<void> removeFromPlaylists(
    {required int audioId, required String? playlistId}) async {
  // get existing playListmodel

  if (playlistId != null) {
    final AudioPlaylistModel? existsPlayListModel =
        await playlistModelAudioBox.get(playlistId);

    //Remove existing audiomodel from favorites
    existsPlayListModel!.playlistAudios
        .removeWhere((existAudioModel) => existAudioModel.audioId == audioId);

    // update the favoties playlist model
    // final AudioPlaylistModel playlistModel = AudioPlaylistModel(
    //   playlistId: playlistId,
    //   playListName: "Favorites",
    //   audioModelList: existsfavoritesListModel.audioModelList,
    // );

    // save to database
    await playlistModelAudioBox.put(playlistId, existsPlayListModel);
  }
}










// AudioPlaylistModel playlistModel = AudioPlaylistModel(
      //     //Add audios of audioPlaylistModel and that playlist which is get.
      //     playlistId: playlistId,
      //     playlistAudios: [
      //       ...playlistAudios,
      //       ...audioPlaylistModel.playlistAudios
      //     ]);

// Future<void> deleteAudios(
//     {required int audioId, required String? playlistId}) async {}