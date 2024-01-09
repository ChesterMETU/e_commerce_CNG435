import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:e_commerce/Widgets/adminProductPage.dart';
import 'package:e_commerce/Widgets/backupList.dart';
import 'package:e_commerce/Widgets/userManagment.dart';
import 'package:e_commerce/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../Widgets/marketPlace.dart';
import '../Widgets/productCreationPage.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

Future<String> getCurrentUser() async {
  print("here");
  final user = await Amplify.Auth.fetchUserAttributes();
  print(user[2].value);
  return user[2].value;
  return "";
}

class _AdminViewState extends State<AdminView> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String name = snapshot.data as String;
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
                            trailing: const Icon(Icons.arrow_forward_ios_sharp),
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
                            trailing: const Icon(Icons.arrow_forward_ios_sharp),
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
                          child: Container(
                            height: height - 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement<void, void>(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  AuthenticatedView(
                                                      child: UserManagement(
                                                name: name,
                                              )),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 150,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: RichText(
                                              textAlign: TextAlign.center,
                                              text: const TextSpan(
                                                text: "Manage Users",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement<void, void>(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  AuthenticatedView(
                                                      child:
                                                          AdminProductPage()),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 150,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: RichText(
                                              textAlign: TextAlign.center,
                                              text: const TextSpan(
                                                text: "Manage Products",
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
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement<void, void>(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            AuthenticatedView(
                                                child: BackupList(
                                          name: name,
                                        )),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 150,
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
                                          text: "Back-up Databases",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          )),
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
