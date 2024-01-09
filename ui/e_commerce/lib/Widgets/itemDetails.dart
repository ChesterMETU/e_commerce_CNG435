import 'dart:convert';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:e_commerce/Widgets/myItemsPage.dart';
import 'package:e_commerce/boxes.dart';
import 'package:e_commerce/bucketItem.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../itemBucket.dart';
import 'bucket.dart';

class ItemDetails extends StatefulWidget {
  final String id;
  final String name;
  final int price;
  final int piece;
  final String category;
  final Uint8List image;
  final String description;
  final String role;
  final int canDelete;
  const ItemDetails(
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
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  SingleValueDropDownController pieceController =
      SingleValueDropDownController();

  Future handleDeleteItem() async {
    var res = await http.delete(
        Uri.parse(
            "https://4151wpvtqb.execute-api.eu-central-1.amazonaws.com/items/${widget.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    var response = await jsonDecode(res.body);
    print(response);
    if (context.mounted) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              AuthenticatedView(child: MyProductsPage()),
        ),
      );
    }
  }

  Future handleAddToBucket() async {
    final user = await Amplify.Auth.getCurrentUser();
    String user_id = user.userId;
    BucketItem items = boxBucketItems.get('bucket');
    int isSame = 0;

    items.items = items.items.where((e) {
      if (e.id == widget.id) {
        isSame = 1;
        e.piece = e.piece + pieceController.dropDownValue!.value as int;
      }
      return true;
    }).toList();

    if (isSame == 0) {
      ItemBucket item = ItemBucket(
          id: widget.id,
          itemID: widget.id,
          creatorID: user_id,
          piece: pieceController.dropDownValue!.value,
          image: widget.image,
          price: widget.price,
          name: widget.name,
          description: widget.description,
          category: widget.category);
      items.items.add(item);
    }
    boxBucketItems.put('bucket', items);
    if (context.mounted) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AuthenticatedView(
              child: BucketPage(
            name: widget.name,
          )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var pieceList = List<int>.generate(widget.piece, (i) => i + 1);
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: Image.memory(widget.image).image,
                      width: 220,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    child: const Text(
                      "Description",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  widget.canDelete == 1
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "Piece: ${widget.piece}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        )
                      : DropDownTextField(
                          onChanged: (select) {
                            setState(() {});
                          },
                          listTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          textFieldDecoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(22),
                            hintText: "Piece",
                            hintStyle: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                          dropdownColor: Colors.white,
                          controller: pieceController,
                          dropDownItemCount: pieceList.length,
                          dropDownList: pieceList
                              .map((c) => DropDownValueModel(
                                  name: c.toString(), value: c))
                              .toList(),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        if (widget.canDelete == 1) {
                          handleDeleteItem();
                        } else {
                          handleAddToBucket();
                        }
                      },
                      child: widget.canDelete == 1
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    text: "Delete",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    text: "Add to Bucket",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 30,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ],
      ),
    ));
  }
}
