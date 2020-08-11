import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';


class EditProfilePage extends StatefulWidget {
  static const routeName = "signupPage";

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  String _name;
  String _address;
  String _phoneNumber;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserModel userProfile = Provider.of<User>(context).userProfile;
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Hexcolor('#0644e3'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,

        elevation: 0,
        title: Text(
          'Edit Profile',style: TextStyle(color: Colors.white,fontSize: 24)
        ),),
      key: _scacffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 50,
              child: Align(
                //alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: TextFormField(
                              validator: (val) {
                                if (val.trim().length > 36) {
                                  return "Name cannot be 36+ characters";
                                }
                                return val.trim().isEmpty
                                    ? "Name cannot be empty."
                                    : null;
                              },
                              onSaved: (val) {
                                _name = val.trim();
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 18),
                              initialValue: userProfile.name,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: TextFormField(
                              validator: (val) {
                                if(val.trim().length>16){
                                  return "Number cannot be 16+ characters";
                                }
                                return val.trim().isEmpty
                                    ? "Number cannot be empty."
                                    : null;
                              },
                              onSaved: (val) {
                                _phoneNumber = val.trim();
                              },
                              keyboardType: TextInputType.phone,
                              style: TextStyle(fontSize: 18),
                              initialValue: userProfile.phoneNumber,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: TextFormField(
                              initialValue: userProfile.address,
                              validator: (val) {
                                if(val.trim().length>360){
                                  return "Address cannot be 360+ characters";
                                }
                                return val.trim().isEmpty
                                    ? "Address cannot be empty."
                                    : null;
                              },
                              onSaved: (val) {
                                _address = val.trim();
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: 'Address',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 12,),
                    if (_isLoading)
                      CircularProgressIndicator(),
                    if (!_isLoading)
                      Container(
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: Hexcolor('#0644e3'),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        width: 250,
                        child: FlatButton(
                          child: Text('Save Changes',
                              style: TextStyle(fontSize: 20, color: Colors.white)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //Only gets here if the fields pass
                              _formKey.currentState.save();
                              _signUp(context);
                            }
                          },
                        ),
                      ),
//                    SizedBox(
//                      height: 20,
//                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _signUp(BuildContext ctx,) async {
    var useruid = Provider.of<User>(ctx,listen: false).userProfile;
    try {
      setState(() {
        _isLoading = true;
      });
        Firestore.instance
            .collection(users_collection)
            .document(useruid.userDocId)
            .updateData({
          'address': _address,
          'name': _name,
          "phoneNumber": _phoneNumber
        });


      await Provider.of<User>(context,listen: false).getCurrentUser(useruid.userDocId);
      Navigator.pop(ctx);

    } on PlatformException catch (err) {
      var message = "An error has occured, please check your credentials.";

      if (err.message != null) {
        message = err.message;
      }

      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
