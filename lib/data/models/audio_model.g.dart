// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioModelAdapter extends TypeAdapter<AudioModel> {
  @override
  final int typeId = 1;

  @override
  AudioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioModel(
      audioPath: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      totalDuration: fields[3] as int,
      audioId: fields[4] as int,
      playCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AudioModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.audioPath)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.totalDuration)
      ..writeByte(4)
      ..write(obj.audioId)
      ..writeByte(5)
      ..write(obj.playCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
