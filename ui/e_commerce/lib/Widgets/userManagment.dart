import 'package:e_commerce/Widgets/userCard.dart';
import 'package:e_commerce/views/adminView.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:e_commerce/data/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../Widgets/marketPlace.dart';
import '../Widgets/productCreationPage.dart';
import '../data/user.dart';

class UserManagement extends StatefulWidget {
  final String name;
  const UserManagement({super.key, required this.name});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  Future<List<User>> getUsers() async {
    var res = await http.get(
        Uri.parse(
            "https://0vx5duwshj.execute-api.eu-north-1.amazonaws.com/users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    var response = await jsonDecode(res.body);

    List<User> users = [];
    try {
      response.forEach((u) {
        if (u["Attributes"] != null) {
          User user = User(
              name: u["Attributes"][2]["Value"],
              userId: u["Attributes"][0]["Value"],
              email: u["Attributes"][3]["Value"],
              createdAt:
                  DateFormat("yyyy-MM-ddTHH:mm:ss").parse(u["UserCreateDate"]),
              status: u["UserStatus"]);

          users.add(user);
        }
      });
    } catch (e) {
      print(e);
    }

    return users;
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data as List<User>;
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
                        child: Column(
                          children: [
                            Column(
                              children: users
                                  .map((u) => UserCard(
                                        email: u.email,
                                        name: u.name,
                                        id: u.userId,
                                        createdAt: u.createdAt,
                                        status: u.status,
                                      ))
                                  .toList(),
                            )
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
