import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
part 'video_model.g.dart';

@HiveType(typeId: 3)
class VideoModel extends HiveObject {
  @HiveField(0)
  final String videoId;

  @HiveField(1)
  final String videoTitle;

  @HiveField(2)
  final String videoPath;

  @HiveField(3)
  int playcount;

  @HiveField(4)
  final Uint8List? thumbnail;

  VideoModel(
      {required this.videoId,
      required this.videoTitle,
      required this.videoPath,
      required this.thumbnail,
      this.playcount = 0});
}
