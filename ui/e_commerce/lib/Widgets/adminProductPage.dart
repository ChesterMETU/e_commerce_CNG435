import 'dart:convert';
import 'dart:typed_data';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:e_commerce/Widgets/itemCard.dart';
import 'package:e_commerce/Widgets/landingPage.dart';
import 'package:e_commerce/Widgets/myItemsPage.dart';
import 'package:e_commerce/Widgets/productCreationPage.dart';
import 'package:e_commerce/data/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../views/adminView.dart';
import 'bucket.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({super.key});
  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  int shouldSort = 0;
  SingleValueDropDownController category = SingleValueDropDownController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<String> user;
  late Future<List<String>> categories;
  late Future<List<Item>> items;

  @override
  void initState() {
    user = getCurrentUser();
    categories = getCategorys();
    items = getItems();
    super.initState();
  }

  Future<String> getCurrentUser() async {
    final user = await Amplify.Auth.fetchUserAttributes();
    return user[2].value;
  }

  Future<List<String>> getCategorys() async {
    var res = await http.get(
        Uri.parse(
            "https://4151wpvtqb.execute-api.eu-central-1.amazonaws.com/itemcategorys"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    var response = await jsonDecode(res.body);
    List<String> categorys = [];
    try {
      response.forEach((var c) {
        categorys.add(c as String);
      });
    } catch (e) {
      print(e);
    }

    return categorys;
  }

  Future<List<Item>> getItems() async {
    var res = await http.get(
        Uri.parse(
            "https://4151wpvtqb.execute-api.eu-central-1.amazonaws.com/items"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    var response = await jsonDecode(res.body);

    List<Item> items = [];

    try {
      if (response.runtimeType != String) {
        response.forEach((var i) {
          Uint8List image;
          image = base64Decode(i["image"]);
          Item item = Item(
              id: i["item_ID"],
              category: i["category"],
              piece: i["piece"],
              name: i["name"],
              price: i["price"],
              image: image,
              description: i["description"]);
          items.add(item);
        });
      }
    } catch (e) {
      print(e);
      print("here");
    }
    return items;
  }

  void sortByCategory(String key) {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([categories, items, user]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> categorys = snapshot.data![0] as List<String>;
            List<Item> items = snapshot.data![1] as List<Item>;
            String name = snapshot.data![2] as String;

            if (category.dropDownValue != null) {
              items = items
                  .where((e) => e.category == category.dropDownValue!.value)
                  .toList();
            }

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
                            "Hello $name",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Home'),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_sharp),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        AuthenticatedView(child: AdminView()),
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
                              title: const Text('Profile'),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_sharp),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        AuthenticatedView(
                                            child: ProductCreation(
                                      name: "name",
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 70, horizontal: 10),
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ListView(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shrinkWrap: false,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: DropDownTextField(
                                              onChanged: (select) {
                                                setState(() {});
                                              },
                                              listTextStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                              textFieldDecoration:
                                                  InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 3,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(22),
                                                hintText: "Sort By Category",
                                                hintStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              dropdownColor: Colors.white,
                                              controller: category,
                                              dropDownItemCount:
                                                  categorys.length,
                                              dropDownList: categorys
                                                  .map((c) =>
                                                      DropDownValueModel(
                                                          name: c, value: c))
                                                  .toList(),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: items
                                .map((i) => ItemCard(
                                      id: i.id,
                                      category: i.category,
                                      piece: i.piece,
                                      price: i.price,
                                      name: i.name,
                                      image: i.image,
                                      description: i.description,
                                      role: "admin",
                                      canDelete: 1,
                                    ))
                                .toList(),
                          )
                        ]),
                      )),
                      Positioned(
                        left: 0,
                        top: 30,
                        child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () =>
                              scaffoldKey.currentState?.openDrawer(),
                        ),
                      ),
                    ],
                  ),
                ) // This trailing comma makes auto-formatting nicer for build methods.
                );
          }

          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SpinKitDualRing(
                size: 60,
                color: Colors.white,
              ),
            ),
          );
        });
  }
}
