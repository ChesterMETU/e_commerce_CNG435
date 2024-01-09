import 'dart:typed_data';

class Item {
  String id;
  String category;
  String name;
  int price;
  int piece;
  Uint8List image;
  String description;
  Item(
      {required this.id,
      required this.category,
      required this.name,
      required this.piece,
      required this.price,
      required this.image,
      required this.description});
}
