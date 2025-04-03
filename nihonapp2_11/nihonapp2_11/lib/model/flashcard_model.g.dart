// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashCardDataAdapter extends TypeAdapter<FlashCardData> {
  @override
  final int typeId = 1;

  @override
  FlashCardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashCardData(
      frontSide: fields[0] as String,
      backSide: fields[1] as String,
      isBookmarked: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FlashCardData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.frontSide)
      ..writeByte(1)
      ..write(obj.backSide)
      ..writeByte(2)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
