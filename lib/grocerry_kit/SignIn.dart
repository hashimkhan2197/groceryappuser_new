import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryappuser/grocerry_kit/sign_up.dart';
import 'package:groceryappuser/grocerry_kit/store_package/stores_list_screen.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:groceryappuser/style_functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  static const routeName = "signInPage";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  bool _isObscured = true;
  Color _eyeButtonColor = Colors.grey[700];
  var _isLoading = false;
  StyleFunctions formFieldStyle = StyleFunctions();
 bool _prefLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _prefLoading = true;
      });
      Provider.of<User>(context,listen: false).tryAutoLogin(context).then((value) {
        setState(() {
          _prefLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
            'Sign in',style: TextStyle(color: Colors.white,fontSize: 24)
        ),

      ),
      key: _scacffoldKey,
      body: _prefLoading == true?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height -70,
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10,),
                CircleAvatar(maxRadius: 80,backgroundColor: Colors.blue,),
                SizedBox(height: 16,),
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
                            return val.trim().isEmpty
                                ? "Email cannot be empty."
                                : null;
                          },
                          onSaved: (val) {
                            _email = val.trim();
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 18),
                          decoration: formFieldStyle.formTextFieldDecoration("E-Mail"),
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
                    ],
                  ),
                ),
                if (_isLoading)
                  CircularProgressIndicator(),
                if (!_isLoading)
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      //borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    //width: 250,
                    child: FlatButton(
                      child: Text('Forgot Password',
                          style: TextStyle(fontSize: 20, color: Colors.grey)),
                      onPressed: () {
                        _formKey.currentState.save();
                        _resetPassword(_email, context);
                      },
                    ),
                  ),
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
                      child: Text('Sign In',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          //Only gets here if the fields pass
                          _formKey.currentState.save();
                          _login(_email, _password, context);
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
                      child: Text('Sign Up',
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return SignUpPage();
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
        ),
      )),
    );
  }

  void _resetPassword(String email, BuildContext ctx) async {
    try {
      await _auth.sendPasswordResetEmail(
          email: email);
      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "A recovery email has been sent to you.",
        ),
        backgroundColor: Theme.of(ctx).primaryColor,
      ));


    } on PlatformException catch (err) {
      var message = "An error has occured, please check your credentials.";

      if (err.message != null) {
        message = err.message;
      }

      if(email == null || email.isEmpty){
        message = "Please enter your registered email";
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
  void _login(email, password, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
          email: email, password: password).then((AuthResult value)async{
        String currentUserId =value.user.uid;

        await Provider.of<User>(context,listen: false).getCurrentUser(currentUserId);
        var prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'userUid': currentUserId,
          },
        );
        prefs.setString('userData', userData);
      }).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StoresListPage()),
        );
      });

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
