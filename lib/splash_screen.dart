import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'dart:async';

import 'package:groceryappuser/grocerry_kit/SignIn.dart';
import 'package:hexcolor/hexcolor.dart';

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
      backgroundColor: Hexcolor('#0644e3'),
      body: Center(
          child: Container(height: 250,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              // color: product.color,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                    image: AssetImage("images/splash.png"), fit: BoxFit.fitWidth)),
          ),),
    );
  }
}
