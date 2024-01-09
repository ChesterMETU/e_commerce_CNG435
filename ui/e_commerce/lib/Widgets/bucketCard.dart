import 'dart:typed_data';
import 'package:e_commerce/Widgets/itemDetails.dart';
import 'package:flutter/material.dart';

class BucketCard extends StatefulWidget {
  final String id;
  final String name;
  final int price;
  final int piece;
  final Uint8List image;
  final String description;
  const BucketCard({
    super.key,
    required this.description,
    required this.id,
    required this.name,
    required this.price,
    required this.piece,
    required this.image,
  });

  @override
  State<BucketCard> createState() => _BucketCardState();
}

class _BucketCardState extends State<BucketCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemDetails(
                    id: widget.id,
                    name: widget.name,
                    price: widget.price,
                    piece: widget.piece,
                    category: "",
                    image: widget.image,
                    description: widget.description,
                    role: "user",
                    canDelete: 0,
                  )),
        );
      },
      child: Center(
          child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          image: Image.memory(widget.image).image,
                          width: 80,
                        ),
                      )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.price} tl',
                        style: const TextStyle(
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: Text(
                widget.piece.toString(),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            )
          ],
        ),
      )),
    );
  }
}
