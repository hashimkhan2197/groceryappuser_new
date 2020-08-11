import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  TextEditingController _helpController = TextEditingController();
  Color _cartItemColor = Colors.white70;
  final _scacffoldKey = GlobalKey<ScaffoldState>();



  @override
  void dispose() {
    _helpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userProfile =
        Provider.of<User>(context, listen: false).userProfile;
    return Scaffold(
      key: _scacffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Hexcolor('#0644e3'),
        elevation: 0,
        title: Text(
          'Help',style: TextStyle(color: Colors.white,fontSize: 24)
        ),),

      body: StreamBuilder(
        stream: Firestore.instance.collection('helpdata').document('helpdata').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),

                ///FeedBack Section
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "Help Section",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 25,),

                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "Email: "+snapshot.data['email'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "Number: "+snapshot.data['number'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                ),

                SizedBox(height: 30,),

                _feedbackInput(
                  controller: _helpController,
                  hint: "Ask your question here.",
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: () {
                      Firestore.instance.collection('help').add({
                        'message': _helpController.text,
                        'number': userProfile.phoneNumber,
                        'name': userProfile.name,
                        'email': userProfile.email
                      }).then((value) {
                        _scacffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            "Your question has been submitted.",
                          ),
                          backgroundColor:Hexcolor('#0644e3'),
                        ));
                      });
                      setState(() {
                        _helpController.clear();
                      });
                    },
                    //color: Theme.of(context).primaryColor,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        }
      ),
    );
  }

  Widget _feedbackInput({
    controller,
    hint,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            color: _cartItemColor),
        padding: EdgeInsets.only(left: 10),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 3,
          //Normal textInputField will be displayed
          maxLines: 10,
          // when user presses enter it will adapt to it
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
          ),
        ),
      ),
    );
  }
}
