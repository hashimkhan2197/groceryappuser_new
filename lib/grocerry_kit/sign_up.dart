import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryappuser/grocerry_kit/store_package/stores_list_screen.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignIn.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = "signupPage";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  String _name;
  String _address;
  String _phoneNumber;
  bool _isObscured = true;
  Color _eyeButtonColor = Colors.grey[700];
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
            'Sign up',style: TextStyle(color: Colors.white,fontSize: 24)
        ),

      ),
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
                Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 28,
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
                      ),Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: TextFormField(
                          validator: (val) {
                            return val.trim().isEmpty
                                ? "email cannot be empty."
                                : null;
                          },
                          onSaved: (val) {
                            _email = val.trim();
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'E-Mail Address',
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
                          validator: (String val) {
                            if (val.trim().isEmpty) {
                              return "Password cannot be empty";
                            } else if (val.trim().length < 8) {
                              return "Password must be 8 characters.";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _password = val.trim();
                          },
                          obscureText: _isObscured,
                          style: TextStyle(fontSize: 18),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (_isObscured) {
                                  setState(() {
                                    _isObscured = false;
                                    _eyeButtonColor =
                                        Theme.of(context).primaryColor;
                                  });
                                } else {
                                  setState(() {
                                    _isObscured = true;
                                    _eyeButtonColor = Colors.grey;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: _eyeButtonColor,
                              ),
                            ),
                            hintText: 'Password',
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

                if (_isLoading)
                  CircularProgressIndicator(),
                if (!_isLoading)
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    width: 250,
                    child: FlatButton(
                      child: Text('Sign Up',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          //Only gets here if the fields pass
                          _formKey.currentState.save();
                          _signUp(_email, _password, context);
                        }
                      },
                    ),
                  ),
                if (!_isLoading)
                  Container(
                    margin: EdgeInsets.only(top: 0, bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      // shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    width: 250,
                    child: FlatButton(
                      child: Text('Sign In',
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return SignInPage();
                        }));
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

  void _signUp(email, password, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      String currentUserId;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((AuthResult value) {
            currentUserId = value.user.uid.toString();
        Firestore.instance
            .collection(users_collection)
            .document(value.user.uid)
            .setData({
          'address': _address,
          'email': _email,
          'name': _name,
          "phoneNumber": _phoneNumber
        });
      });

      await Provider.of<User>(context,listen: false).getCurrentUser(currentUserId);
      var prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'userUid': currentUserId,
        },
      );
      prefs.setString('userData', userData);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
            return StoresListPage();
          }));

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
