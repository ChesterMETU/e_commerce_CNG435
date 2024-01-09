import 'package:e_commerce/Widgets/dbBackUpCard.dart';
import 'package:e_commerce/Widgets/userCard.dart';
import 'package:e_commerce/data/dbBackup.dart';
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

class BackupList extends StatefulWidget {
  final String name;
  const BackupList({super.key, required this.name});

  @override
  State<BackupList> createState() => _BackupListState();
}

class _BackupListState extends State<BackupList> {
  int isloading = 0;

  Future<void> handleCreateBackUp() async {
    setState(() {
      isloading = 1;
    });
    var res = await http.get(
        Uri.parse(
            "https://5q3rsscxvf.execute-api.eu-central-1.amazonaws.com/backupDb"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    var response = await jsonDecode(res.body);

    if (context.mounted) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AuthenticatedView(
              child: BackupList(
            name: "name",
          )),
        ),
      );
    }
  }

  Future<List<DbBackup>> getUsers() async {
    var res = await http.get(
        Uri.parse(
            "https://5q3rsscxvf.execute-api.eu-central-1.amazonaws.com/listBackupDb"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    var response = await jsonDecode(res.body);

    List<DbBackup> backups = [];
    try {
      response.forEach((u) {
        DbBackup backup = DbBackup(
            id: u["BackupArn"],
            status: u["BackupStatus"],
            name: u["BackupName"],
            creationTime: DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(u["BackupCreationDateTime"]),
            table: u["TableName"]);

        backups.add(backup);
      });
    } catch (e) {
      print(e);
    }

    return backups;
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DbBackup> backups = snapshot.data as List<DbBackup>;
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
                              children: backups
                                  .map((u) => DbBackupCard(
                                        id: u.id,
                                        table: u.table,
                                        creationTime: u.creationTime,
                                        name: u.name,
                                        status: u.status,
                                      ))
                                  .toList(),
                            ),
                            InkWell(
                              onTap: () {
                                if (isloading == 0) {
                                  handleCreateBackUp();
                                }
                              },
                              child: isloading == 0
                                  ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: RichText(
                                          textAlign: TextAlign.center,
                                          text: const TextSpan(
                                            text: "Create",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                    )
                                  : const Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: SpinKitDualRing(
                                          size: 60,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
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
