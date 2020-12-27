// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsDataAdapter extends TypeAdapter<_SettingsData> {
  @override
  final int typeId = 0;

  @override
  _SettingsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _SettingsData()..themeMode = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, _SettingsData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.themeMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
