import 'dart:async';
import 'package:camera/camera.dart';
import 'package:mark/services/authentication.dart';
import 'package:mark/ui/admin_side/admin_page.dart';
import 'package:mark/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:mark/ui/admin or user.dart';
import 'package:mark/ui/login_page.dart';

List<CameraDescription> cameras;
var frontCamera;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  //final frontCamera = cameras.firstWhere(
  //      (camera) => camera.lensDirection == CameraLensDirection.back,
  //);
  runApp(MyApp());
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Attendance",
      debugShowCheckedModeBanner: false,
      home: SplashScreen());

  }
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  // Set the timer duration for the splash screen
  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  // Navigate to root page after splash screen
  void navigationPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RootPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.jpg'),
        ),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

//TODO: Change the Auth state management to StreamBuilder

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool admin= false;

  BaseAuth auth = Auth();
  @override
  void initState() {
    super.initState();
    auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user.username;
          authStatus = AuthStatus.LOGGED_IN;
          admin=user.admin;
        }
        else{authStatus = AuthStatus.NOT_LOGGED_IN;}
      });
    });
  }


  void loginCallback() {
    auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.username;
        admin = user.admin;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }
  // Logout Callback
  Future<void> logoutCallback() async {
    await auth.signOut();
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      admin=false;
    });
  }

  // Waiting Screen Widget
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return  //LoginPage(
          UserorAdmin(
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          print(admin);
          if (admin) {
            return  AdminPage(
              logoutCallback: logoutCallback,
              userid: _userId,
            );
          } else {
            // Employee
            return  HomePage(
              logoutCallback: logoutCallback,
              userId: _userId,
            );
          }
        }else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
