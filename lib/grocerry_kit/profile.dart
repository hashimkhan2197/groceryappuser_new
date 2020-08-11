import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:groceryappuser/grocerry_kit/SignIn.dart';
import 'package:groceryappuser/grocerry_kit/sub_pages/edit_profile_page.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _helpController = TextEditingController();
  Color _cartItemColor = Colors.white70;

  @override
  void dispose() {
    _addressController.dispose();
    _helpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userProfile =
        Provider.of<User>(context, listen: true).userProfile;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        centerTitle: true,automaticallyImplyLeading: false,
        backgroundColor: Hexcolor('#0644e3'),
        elevation: 0,
        title: Text(
          'My Profile',style: TextStyle(color: Colors.white,fontSize: 24)
        ),

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: Firestore.instance.collection(users_collection)
                      .document(userProfile.userDocId).snapshots(),
                    builder: (context,AsyncSnapshot snapshot) {
                      var data = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ///Profile Data Section
                          _myProfileData(
                              icon: Icons.person,
                              heading: "Name",
                              data: data['name']),
                          _myProfileData(
                              icon: Icons.email,
                              heading: "Email",
                              data: data['email']),
                          _myProfileData(
                              icon: Icons.phone,
                              heading: "Phone",
                              data: data['phoneNumber']),
                          _myProfileData(
                              icon: Icons.location_city,
                              heading: "address",
                              data: data['address']),
                          SizedBox(height: 16,),
//                      ///Change Address Section
//                      _textAddressInput(
//                          controller: _addressController,
//                          hint: "Change to new Address",
//                          icon: Icons.location_city),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return EditProfilePage();
                                }));
                              },
                              //color: Theme.of(context).primaryColor,
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,fontSize: 20
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              onPressed: (){
                                Provider.of<User>(context, listen: false)
                                    .clearSharedPreferences()
                                    .then((value) {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                        return SignInPage();
                                      }),(Route<dynamic> route) => false);
                                });
                              },
                              //color: Theme.of(context).primaryColor,
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,fontSize: 20
                                ),
                              ),
                            ),
                          ),


                        ],
                      );
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _myProfileData({IconData icon, heading, data}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            color: _cartItemColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10.0),
            Icon(
              icon,
              color: Colors.grey[500],
              size: 25,
            ),
            SizedBox(width: 10.0),
            Text(
              heading,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(width: 20.0),
            Text(
              data,
              maxLines: 5,
              style: TextStyle(fontSize: 20, ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textAddressInput({TextEditingController controller, hint, icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        //margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            color: _cartItemColor),
        padding: EdgeInsets.only(top: 13),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          //Normal textInputField will be displayed
          maxLines: 5,
          // when user presses enter it will adapt to it
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
        ),
      ),
    );
  }

}
