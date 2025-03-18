import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/data/models/video/video_playlist_model.dart';

late LazyBox<VideoPlaylistModel> playlistModelVideoBox;

// Add to playlist (Recents, favourites and custom)
Future<void> addVideoToPlaylist(
    {String? playlistId,
    List<VideoModel>? playlistVideos,
    String? playlistName}) async {
playlistVideos ??= [];

  if (playlistId == null) {
    //For custom playlists when creating for first time
    playlistId ??= DateTime.now().microsecondsSinceEpoch.toString();
    VideoPlaylistModel playlistModel = VideoPlaylistModel(
        playlistId: playlistId,
        playlistName: playlistName!,
        playlistVideos: playlistVideos);

    await playlistModelVideoBox.put(playlistId, playlistModel);
  } else {
    VideoPlaylistModel? videoPlaylistModel = await playlistModelVideoBox
        .get(playlistId); //If a playlist already exists, get its id.

    if (videoPlaylistModel != null) {
      //If the videoPlaylistModel already contains some videos,
      for (VideoModel playlistVideo in playlistVideos) {
        //playlistVideos = Videos of the playlist that is get.
        videoPlaylistModel.playlistVideos.removeWhere(
            //remove video from videoPlaylistModel if playlistVideos contains the same video.
            (playlistClip) => playlistClip.videoId == playlistVideo.videoId);
      }

      List<VideoModel> temp = List.from(videoPlaylistModel.playlistVideos);
      videoPlaylistModel.playlistVideos.clear();

      videoPlaylistModel.playlistVideos.addAll(temp + playlistVideos);
    
      await playlistModelVideoBox.put(playlistId, videoPlaylistModel);
    } else {
      VideoPlaylistModel playlistModel = VideoPlaylistModel(
          //If videoPlaylistModel is empty.
          playlistId: playlistId,
          playlistName: playlistName!,
          playlistVideos: playlistVideos);

      await playlistModelVideoBox.put(playlistId, playlistModel);
    }
  }
}

// Get recently played videos
Future<List<VideoModel>> getRecentlyVideos() async {
  //Get the videos to a list.
  List<VideoModel> recentlyVideos = [];
  final VideoPlaylistModel? recentlyPlayed =
      await playlistModelVideoBox.get("recentlyPlayed");
  if (recentlyPlayed != null) {
    recentlyVideos.addAll(recentlyPlayed.playlistVideos);
  }

  return recentlyVideos.reversed.toList();
}

// Get favourite videos
Future<List<VideoModel>> getFavouriteVideos() async {
  //Get the videos to a list.
  List<VideoModel> favouriteVideos = [];
  final VideoPlaylistModel? favourites =
      await playlistModelVideoBox.get("favourite");
  if (favourites != null) {
    favouriteVideos.addAll(favourites.playlistVideos);
  }

  return favouriteVideos;
}

// Get videos of each playlists
Future<List<VideoModel>> getCustomVideos(String playlistId) async {
  //Get the videos to a list.
  List<VideoModel> customVideos = [];
  final VideoPlaylistModel? customVideo =
      await playlistModelVideoBox.get(playlistId);
  if (customVideo != null) {
    customVideos.addAll(customVideo.playlistVideos);
  }

  return customVideos;
}

// Get custom playlists
Future<List<VideoPlaylistModel>> getVideosPlaylists() async {
  //Get playlists to a list.
  List<VideoPlaylistModel> playlists = [];
  for (String key in playlistModelVideoBox.keys) {
    VideoPlaylistModel? videoPlaylist = await playlistModelVideoBox.get(key);
    if (videoPlaylist != null) {
      playlists.add(videoPlaylist);
    }
  }

  playlists.removeWhere((VideoPlaylistModel playlist) =>
      playlist.playlistId == "recentlyPlayed" ||
      playlist.playlistId == "favourite");
  return playlists;
}


Future<void> removeVideosFromPlaylists(
    {required String videoId, required String? playlistId}) async {
  // get existing playListmodel

  if (playlistId != null) {
    final VideoPlaylistModel? existsPlayListModel =
        await playlistModelVideoBox.get(playlistId);

    //Remove existing audiomodel from favorites
    existsPlayListModel!.playlistVideos
        .removeWhere((existVideoModel) => existVideoModel.videoId == videoId);

    // update the favoties playlist model
    // final AudioPlaylistModel playlistModel = AudioPlaylistModel(
    //   playlistId: playlistId,
    //   playListName: "Favorites",
    //   audioModelList: existsfavoritesListModel.audioModelList,
    // );

    // save to database
    await playlistModelVideoBox.put(playlistId, existsPlayListModel);
  }
}

Future<void> updatePlaylistVideo(
    {required String? playlistId, required String newPlaylistName}) async {
  if (playlistId != null) {
    final VideoPlaylistModel? playlist =
        await playlistModelVideoBox.get(playlistId);
    playlist!.playlistName = newPlaylistName;
    // Save the updated playlist back into the Hive box.
    await playlistModelVideoBox.put(playlistId, playlist);
  } else {
    debugPrint("Playlist not found for id: $playlistId");
  }
}

Future<void> deletePlaylistVideo({required String? playlistId}) async {

  if (playlistId != null) {
    await playlistModelVideoBox.delete(playlistId);
  }
}









  // VideoPlaylistModel playlistModel = VideoPlaylistModel(
      //     //Add videos of videoPlaylistModel and that playlist which is get.
      //     playlistId: playlistId,
      //     playlistName: playlistName,
      //     playlistVideos: [
      //       ...playlistVideos,
      //       ...videoPlaylistModel.playlistVideos
      //     ]);

