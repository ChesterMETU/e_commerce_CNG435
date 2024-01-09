// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemBucket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemBucketAdapter extends TypeAdapter<ItemBucket> {
  @override
  final int typeId = 2;

  @override
  ItemBucket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemBucket(
      creatorID: fields[1] as String,
      itemID: fields[0] as String,
      piece: fields[2] as int,
      name: fields[3] as String,
      image: fields[5] as Uint8List,
      price: fields[4] as int,
      id: fields[6] as String,
      description: fields[7] as String,
      category: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemBucket obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.itemID)
      ..writeByte(1)
      ..write(obj.creatorID)
      ..writeByte(2)
      ..write(obj.piece)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemBucketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
