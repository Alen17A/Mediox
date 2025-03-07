import 'package:hive/hive.dart';
import 'package:mediox/data/models/video/video_model.dart';
part 'video_playlist_model.g.dart';

@HiveType(typeId: 4)
class VideoPlaylistModel {
  @HiveField(0)
  final String playlistId;

  @HiveField(1)
  final String playlistName;

  @HiveField(2)
  final List<VideoModel> playlistVideos;

  VideoPlaylistModel(
      {required this.playlistId,
      required this.playlistName,
      required this.playlistVideos});
}
