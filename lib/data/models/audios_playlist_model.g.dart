// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audios_playlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioPlaylistModelAdapter extends TypeAdapter<AudioPlaylistModel> {
  @override
  final int typeId = 2;

  @override
  AudioPlaylistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioPlaylistModel(
      playlistId: fields[0] as String,
      playlistName: fields[1] as String,
      playlistAudios: (fields[2] as List).cast<AudioModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, AudioPlaylistModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.playlistId)
      ..writeByte(1)
      ..write(obj.playlistName)
      ..writeByte(2)
      ..write(obj.playlistAudios);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioPlaylistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
