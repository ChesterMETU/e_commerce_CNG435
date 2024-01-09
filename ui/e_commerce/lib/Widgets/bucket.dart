import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:e_commerce/Widgets/bucketCard.dart';
import 'package:e_commerce/Widgets/productCreationPage.dart';
import 'package:e_commerce/boxes.dart';
import 'package:e_commerce/bucketItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'marketPlace.dart';
import 'myItemsPage.dart';

class BucketPage extends StatefulWidget {
  const BucketPage({super.key, required this.name});

  final String name;

  @override
  State<BucketPage> createState() => _BucketPageState();
}

class _BucketPageState extends State<BucketPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late BucketItem items;
  int isloading = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = boxBucketItems.get('bucket');
  }

  void handleRemove(String itemID) {
    setState(() {
      items.items = items.items.where((e) => e.id != itemID).toList();
      boxBucketItems.put('bucket', items);
    });
  }

  Future<void> handleComplete() async {
    setState(() {
      isloading = 1;
    });

    Map data = {"items": []};

    items = boxBucketItems.get('bucket');

    items.items.forEach((e) {
      data["items"]
          .add({"id": e.id, "piece": e.piece, "creator_id": e.creatorID});
    });

    var body = json.encode(data);
    var res = await http.post(
        Uri.parse(
            "https://6v11idz44b.execute-api.eu-central-1.amazonaws.com/completepurchase"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    print(res.statusCode);
    var response = json.decode(res.body);
    print(response);

    items.items = [];

    boxBucketItems.put('bucket', items);

    if (context.mounted) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              const AuthenticatedView(child: MarketPlace()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Hello ${widget.name}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Market Place'),
                    trailing: const Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const AuthenticatedView(child: MarketPlace()),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('My Products'),
                    trailing: const Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              AuthenticatedView(child: MyProductsPage()),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Sell Product'),
                    trailing: const Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => AuthenticatedView(
                              child: ProductCreation(
                            name: widget.name,
                          )),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Profiles'),
                    trailing: const Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Bucket'),
                    trailing: const Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => AuthenticatedView(
                              child: BucketPage(
                            name: widget.name,
                          )),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            ListTile(
              title: const SignOutButton(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 70, horizontal: 10),
                child: Column(
                  children: [
                    items.items.isEmpty
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text(
                              "Bucket is empty",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Column(
                              children: [
                                Column(
                                  children: items.items
                                      .map((i) => Column(
                                            children: [
                                              Column(
                                                children: [
                                                  BucketCard(
                                                    description: i.description,
                                                    id: i.id,
                                                    piece: i.piece,
                                                    price: i.price,
                                                    name: i.name,
                                                    image: i.image,
                                                  )
                                                ],
                                              ),
                                              isloading == 0
                                                  ? InkWell(
                                                      onTap: () {
                                                        handleRemove(i.id);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 15),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        15))),
                                                        child: RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text:
                                                                const TextSpan(
                                                              text: "Remove",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            )),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                    isloading == 0
                        ? InkWell(
                            onTap: () {
                              if (items.items.isEmpty) return;
                              handleComplete();
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    text: "Complete",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                            ),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: SpinKitDualRing(
                                size: 60,
                                color: Colors.black,
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
                icon: const Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
