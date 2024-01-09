import 'dart:convert';
import 'dart:typed_data';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:e_commerce/Widgets/itemDetails.dart';
import 'package:e_commerce/Widgets/userManagment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class UserCard extends StatefulWidget {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final String status;
  const UserCard(
      {super.key,
      required this.email,
      required this.name,
      required this.id,
      required this.createdAt,
      required this.status});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  int isloading = 0;
  Future<void> handleDeleteUser() async {
    var res = await http.delete(
        Uri.parse(
            "https://0vx5duwshj.execute-api.eu-north-1.amazonaws.com/users/${widget.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    var response = await jsonDecode(res.body);
    print(response);

    if (context.mounted) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AuthenticatedView(
              child: UserManagement(
            name: "name",
          )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Name: ${widget.name}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "E-mail: ${widget.email}",
                        style: const TextStyle(
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Created At: ${widget.createdAt}",
                        style: const TextStyle(
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Account Status: ${widget.status}",
                        style: const TextStyle(
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          if (isloading == 0) {
                            handleDeleteUser();
                          }
                        },
                        child: isloading == 0
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                      text: "Delete",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                              )
                            : const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: SpinKitDualRing(
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      )
                    ],
                  ))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
