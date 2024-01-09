import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:e_commerce/Widgets/marketPlace.dart';
import 'package:e_commerce/views/adminView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<bool> getUserRole() async {
    final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
    AWSResult<CognitoUserPoolTokens, AuthException> userPoolTokensResult =
        session.userPoolTokensResult;
    final groups = userPoolTokensResult.value.idToken.groups;

    return groups.contains('admin') ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isAdmin = snapshot.data as bool;
            if (isAdmin) {
              return AuthenticatedView(
                child: AdminView(),
              );
            }
            return AuthenticatedView(
              child: MarketPlace(),
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
