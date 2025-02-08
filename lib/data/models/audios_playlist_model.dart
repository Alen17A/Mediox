import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/models/audio_model.dart';
part 'audios_playlist_model.g.dart';

@HiveType(typeId: 2)
class AudioPlaylistModel {
  @HiveField(0)
  final String playlistId;

  @HiveField(1)
  final String playlistName;

  @HiveField(2)
  final List<AudioModel> playlistAudios;

  AudioPlaylistModel(
      {required this.playlistId,
      required this.playlistName,
      required this.playlistAudios});
}
