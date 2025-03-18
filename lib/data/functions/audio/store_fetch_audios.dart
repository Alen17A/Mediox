import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

late LazyBox<AudioModel> audioBox;

Future<void> fetchMP3SongsWithHive() async {
  OnAudioQuery audioQuery = OnAudioQuery();
  bool hasPermission = await audioQuery.checkAndRequest();

  // check storage access permission
  if (hasPermission) {
    var allSongs = await audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      path: "/storage/emulated/0/Music",
    );
    var mp3Songs = allSongs.where((song) {
      return song.fileExtension == "mp3";
    }).toList();

    for (var song in mp3Songs) {
      var audioModel = AudioModel(
        audioPath: song.data,
        title: song.title,
        artist: song.artist ?? 'Unknown',
        totalDuration: song.duration!,
        audioId: song.id,
      );
      if (!checkSong(audioModel.audioId)) {
        await audioBox.put(audioModel.audioId, audioModel);
      }
    }
  }
}

bool checkSong(int songId) {
  return audioBox.containsKey(songId);
}

Future<List<AudioModel>> getSongs() async {
  List<AudioModel> audios = [];
  for (int key in audioBox.keys) {
    AudioModel? audioModel = await audioBox.get(key);
    if (audioModel != null) {
      audios.add(audioModel);
    }
  }
  return audios;
}

// Future<void> deleteAudio({required int audioId}) async {
//   await audioBox.delete(audioId);
// }

Future<List<AudioModel>> mostlyAudios() async {
  List<AudioModel> audios = [];
  for (int key in audioBox.keys) {
    AudioModel? audioModel = await audioBox.get(key);
    if (audioModel != null) {
      if (audioModel.playCount > 5) {
        audios.add(audioModel);
      }
    }
  }
  audios.sort((a, b) => b.playCount.compareTo(a.playCount));
  return audios;
}

// Future<List<SongModel>> fetchMP3SongsWithoutHive() async {
//   var allSongs = await _audioQuery.querySongs(
//     sortType: SongSortType.DATE_ADDED,
//   );
//   var mp3Songs = allSongs.where((song) {
//     return song.fileExtension == "mp3";
//   }).toList();

//   return mp3Songs;
// }
