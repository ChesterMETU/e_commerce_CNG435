import 'package:e_commerce/Widgets/landingPage.dart';
import 'package:e_commerce/Widgets/marketPlace.dart';
import 'package:e_commerce/boxes.dart';
import 'package:e_commerce/bucketItem.dart';
import 'package:e_commerce/views/adminView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'itemBucket.dart' as item_bucket;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BucketItemAdapter());
  Hive.registerAdapter(item_bucket.ItemBucketAdapter());
  boxBucketItems = await Hive.openBox<BucketItem>('bucketItemBox');
  List<item_bucket.ItemBucket> items = [];
  boxBucketItems.put('bucket', BucketItem(items: items));
  BucketItem test = boxBucketItems.get('bucket');
  print(test.items);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: MyHomePage(
            title: "title") //const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      safePrint('Successfully configured');
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Authenticator(
      initialStep: AuthenticatorStep.onboarding,
      child: MaterialApp(home: AuthenticatedView(child: LandingPage())),
    );
  }
}
