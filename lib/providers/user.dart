import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/grocerry_kit/home_page.dart';
import 'package:groceryappuser/grocerry_kit/store_package/stores_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'collection_names.dart';


class UserModel {
  String userDocId;
  String name;
  String address;
  String phoneNumber;
  String email;

  UserModel(
      {@required this.address,
        @required this.email,
        @required this.name,
        @required this.userDocId,
        @required this.phoneNumber,});
}


class User with ChangeNotifier{

  String _name ='name';
  String _address='address';
  String _phoneNumber='phoneNumber';
  String _email = 'email';

  UserModel _userProfile ;
  UserModel get userProfile => _userProfile;
  String _userStoreId ;
  String get userStoreId => _userStoreId;
  String _userStoreDocId ;
  String get userStoreDocId => _userStoreId;
  String _userStoreName ;
  String get userStoreName => _userStoreName;


  Future<void> clearSharedPreferences()async{
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> setUserStoreId({String storeId,String storeName,String storeDocId})async{


    _userStoreId = storeId;
    _userStoreDocId = storeDocId;
    _userStoreName = storeName;

    var prefs = await SharedPreferences.getInstance();
    final userStoreData = json.encode(
      {
        'userStoreName':storeName,
        'userStoreId': storeId,
        'userStoreDocId': storeDocId
      },
    );
    prefs.remove('userStoreData');
    prefs.setString('userStoreData', userStoreData);

  }

  Future<bool> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    String userUid = extractedUserData['userUid'];
    await getCurrentUser(userUid);
    if(!prefs.containsKey('userStoreData')){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StoresListPage()),
      );
    }else{
      final extractedStoreData = json.decode(prefs.getString('userStoreData')) as Map<String,Object>;
      _userStoreName = extractedStoreData['userStoreName'];
      _userStoreId = extractedStoreData['userStoreId'];
      _userStoreDocId = extractedStoreData['userStoreDocId'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage(storeDocId: _userStoreDocId,storeName: _userStoreName,)),
      );
    }
    notifyListeners();
    return true;
  }



  Future<void> getCurrentUser(String currentUserId) async {
    await Firestore.instance.collection(users_collection).document(currentUserId).get().then((value){
      _userProfile = convertToUserModel(value);
    }).catchError((error) {
      throw error;
    });

    notifyListeners();
  }

  UserModel convertToUserModel(DocumentSnapshot docu) {
    var doc = docu.data;
    return UserModel(
      email: doc[_email],
      name: doc[_name],
      address: doc[_address],
      phoneNumber: doc[_phoneNumber],
      userDocId: docu.documentID
    );
  }



}