// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucketItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BucketItemAdapter extends TypeAdapter<BucketItem> {
  @override
  final int typeId = 1;

  @override
  BucketItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BucketItem(
      items: (fields[0] as List).cast<ItemBucket>(),
    );
  }

  @override
  void write(BinaryWriter writer, BucketItem obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BucketItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
