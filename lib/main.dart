import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_wachup/helper/helper_function.dart';
import 'package:flutter_wachup/pages/auth/splash_screen.dart';
import 'package:flutter_wachup/pages/home_page.dart';
import 'package:flutter_wachup/shared/constants.dart';
import 'package:flutter_wachup/pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'fil']);
  if (kIsWeb) {
    // run for web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.apiId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    // run for android, ios
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    //getUserLoggedInStatus();
    getUserLoggedInStatusOffline();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  // offline
  getUserLoggedInStatusOffline() async {
    setState(() {
      isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //timeDilation = 0.5;
    return LocaleBuilder(
        builder: (locale) => MaterialApp(
            localizationsDelegates: Locales.delegates,
            supportedLocales: Locales.supportedLocales,
            locale: locale,
            theme: ThemeData(
              primaryColor: Constants().customColor3,
              fontFamily: 'WorkSans',
              scaffoldBackgroundColor: Constants().customBackColor,
              //visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            debugShowCheckedModeBanner: false,
            title: "Wachup",
            // home: isSignedIn ? const HomePage() : const LoginPage());
            home: const SplashScreen()));
  }
}
