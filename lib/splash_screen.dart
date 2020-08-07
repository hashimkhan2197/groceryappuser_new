import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:groceryappuser/grocerry_kit/SignIn.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _url = '';

  // Splash Screen Time
  @override
  void initState() {
    Timer(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return SignInPage();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    Firestore.instance.collection('splashImage').document('splashImage').get().then((value){
//      _url = value.data['url'];
//    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: CircleAvatar(
            backgroundColor: Colors.blue,
        maxRadius: 150,
        child: Center(
          child: Text(
            "Logo Here",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      )),
    );
  }
}
