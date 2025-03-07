// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_playlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoPlaylistModelAdapter extends TypeAdapter<VideoPlaylistModel> {
  @override
  final int typeId = 4;

  @override
  VideoPlaylistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoPlaylistModel(
      playlistId: fields[0] as String,
      playlistName: fields[1] as String,
      playlistVideos: (fields[2] as List).cast<VideoModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, VideoPlaylistModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.playlistId)
      ..writeByte(1)
      ..write(obj.playlistName)
      ..writeByte(2)
      ..write(obj.playlistVideos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoPlaylistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
