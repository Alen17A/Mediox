import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
part 'audio_model.g.dart';

@HiveType(typeId: 1)
class AudioModel {
  @HiveField(0)
  final String audioPath;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final int totalDuration;

  @HiveField(4)
  final int audioId;

  @HiveField(5)
  final Uint8List? audioImage;

  AudioModel({
    required this.audioPath,
    required this.title,
    required this.artist,
    required this.totalDuration,
    required this.audioId,
    this.audioImage,
  });
}
