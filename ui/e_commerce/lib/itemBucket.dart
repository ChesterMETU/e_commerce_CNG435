import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'itemBucket.g.dart';

@HiveType(typeId: 2)
class ItemBucket {
  ItemBucket(
      {required this.creatorID,
      required this.itemID,
      required this.piece,
      required this.name,
      required this.image,
      required this.price,
      required this.id,
      required this.description,
      required this.category});

  @HiveField(0)
  String itemID;

  @HiveField(1)
  String creatorID;

  @HiveField(2)
  int piece;

  @HiveField(3)
  String name;

  @HiveField(4)
  int price;

  @HiveField(5)
  Uint8List image;

  @HiveField(6)
  String id;

  @HiveField(7)
  String description;

  @HiveField(8)
  String category;
}
