import 'package:hive/hive.dart';

import 'itemBucket.dart';

part 'bucketItem.g.dart';

@HiveType(typeId: 1)
class BucketItem {
  BucketItem({required this.items});

  @HiveField(0)
  List<ItemBucket> items;
}
