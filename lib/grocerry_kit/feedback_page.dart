import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _improvementController = TextEditingController();
  final _scacffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _improvementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userProfile =
        Provider.of<User>(context, listen: false).userProfile;
    return Scaffold(
      key: _scacffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          'Feedback',style: TextStyle(color: Colors.white,fontSize: 24)
        ),
      ),
      body: SingleChildScrollView(
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
                "Feedback Section",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 40,),
            _feedbackInput(
              controller: _improvementController,
              hint: "Please let us know how we can improve...",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  Firestore.instance.collection('improvements').add({
                    'message': _improvementController.text,
                    'number': userProfile.phoneNumber,
                    'name': userProfile.name
                  }).then((value) {
                    _scacffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        "Your Feedback has been submitted.",
                      ),
                      backgroundColor: Colors.blue,
                    ));
                  });
                  setState(() {
                    _improvementController.clear();
                  });
                },
                //color: Colors.white,
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
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
            color: Colors.white70),
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
