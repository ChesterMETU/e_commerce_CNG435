import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:e_commerce/Widgets/bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'marketPlace.dart';
import 'package:http/http.dart' as http;

import 'myItemsPage.dart';

class ProductCreation extends StatefulWidget {
  const ProductCreation({super.key, required this.name});
  final String name;
  @override
  State<ProductCreation> createState() => _ProductCreationState();
}

class _ProductCreationState extends State<ProductCreation> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  File? selectedImage;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final pieceController = TextEditingController();
  final descriptionController = TextEditingController();
  int isloading = 0;

  Future pickImageFromGallery() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);

    if (returnedImage != null) {
      setState(() {
        selectedImage = File(returnedImage!.path);
      });
    }
  }

  Future pickImageFromCamera() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640);

    if (returnedImage != null) {
      setState(() {
        selectedImage = File(returnedImage!.path);
      });
    }
  }

  Future<void> handleCreate() async {
    setState(() {
      isloading = 1;
    });
    var bytes = await selectedImage!.readAsBytes();
    var base64img = base64Encode(bytes);
    final user = await Amplify.Auth.getCurrentUser();
    String user_id = user.userId;
    Map data = {
      "name": nameController.value.text,
      "price": int.parse(priceController.value.text),
      "piece": int.parse(pieceController.value.text),
      "creator_id": user_id,
      "product_description": descriptionController.text,
      "file": base64img
    };

    var body = json.encode(data);
    var res = await http.put(
        Uri.parse(
            "https://4151wpvtqb.execute-api.eu-central-1.amazonaws.com/items"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    var response = json.decode(res.body);
    print(response);
    if (context.mounted) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              const AuthenticatedView(child: MarketPlace()),
        ),
      );
    }
    setState(() {
      isloading = 0;
    });
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
                                AuthenticatedView(child: MarketPlace()),
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
                            builder: (BuildContext context) =>
                                AuthenticatedView(
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
                            builder: (BuildContext context) =>
                                AuthenticatedView(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                pickImageFromGallery();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: RichText(
                                    text: const TextSpan(
                                  text: "Pick from Gallery",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          Container(
                            child: InkWell(
                              onTap: () {
                                pickImageFromCamera();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                child: RichText(
                                    text: const TextSpan(
                                  text: "Pick from Camera",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              height: 250,
                            )
                          : const Text(
                              "Please Select an Image",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: isloading == 1 ? false : true,
                        obscureText: false,
                        controller: nameController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(22),
                          hintText: "Name of the Product",
                          hintStyle: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: isloading == 1 ? false : true,
                        obscureText: false,
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(22),
                          hintText: "Price",
                          hintStyle: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: isloading == 1 ? false : true,
                        obscureText: false,
                        controller: pieceController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(22),
                          hintText: "Piece",
                          hintStyle: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: isloading == 1 ? false : true,
                        maxLines: 8,
                        obscureText: false,
                        controller: descriptionController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(22),
                          hintText: "Description",
                          hintStyle: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: isloading == 1
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: SpinKitDualRing(
                                    size: 60,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  handleCreate();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        text: "Create",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
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
                  icon: const Icon(Icons.menu),
                  onPressed: () => scaffoldKey.currentState?.openDrawer(),
                ),
              ),
            ],
          ),
        ));
  }
}
