// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardCollectionAdapter extends TypeAdapter<CardCollection> {
  @override
  final int typeId = 0;

  @override
  CardCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardCollection(
      title: fields[1] as String,
      desc: fields[2] as String,
    )..flashcards = (fields[0] as HiveList).castHiveList();
  }

  @override
  void write(BinaryWriter writer, CardCollection obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.flashcards)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.desc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
