import 'dart:typed_data';
import 'package:e_commerce/Widgets/itemDetails.dart';
import 'package:e_commerce/Widgets/itemDetailsAdmin.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String id;
  final String name;
  final int price;
  final int piece;
  final String category;
  final Uint8List image;
  final String description;
  final String role;
  final int canDelete;
  const ItemCard(
      {super.key,
      required this.id,
      required this.name,
      required this.price,
      required this.piece,
      required this.category,
      required this.image,
      required this.description,
      required this.role,
      required this.canDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (role == "admin") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailsAdmin(
                      id: id,
                      name: name,
                      price: price,
                      piece: piece,
                      category: category,
                      image: image,
                      description: description,
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetails(
                      id: id,
                      name: name,
                      price: price,
                      piece: piece,
                      category: category,
                      image: image,
                      description: description,
                      role: role,
                      canDelete: canDelete,
                    )),
          );
        }
      },
      child: Center(
          child: Container(
        margin: const EdgeInsets.only(bottom: 10),
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
                          image: Image.memory(image).image,
                          width: 80,
                        ),
                      )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$price tl',
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
              child: const Icon(Icons.arrow_forward_ios_rounded),
            )
          ],
        ),
      )),
    );
  }
}
