import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/grocerry_kit/sub_pages/order_Page.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  static const routeName = "/orderHistory";

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    UserModel userProfile = Provider.of<User>(context).userProfile;

    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Hexcolor('#0644e3'),
        automaticallyImplyLeading: false,
        title: Text(
          "Order History",
          style: TextStyle(color: Colors.white,fontSize: 24),
        ),

      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//            Container(
//              padding: EdgeInsets.all(16),
//              child: Text(
//                "Order History",
//                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.grey),
//              ),
//            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(orders_Collection)
                      .where('userUid', isEqualTo: userProfile.userDocId)
                  .orderBy('dateTime',descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                        break;
                      default:
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            var data = snapshot.data.documents[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return OrderPage(data);
                                }));
                              },
                              child: Container(margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 2),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white70),
                                child: ListTile(
                                  title: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 8, top: 4 ,bottom: 4),
                                    child: Text(
                                      data['storeName'],
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                      "Date: " +
                                          data['dateTime'].split('T').first,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500
                                      )),
                                  //    trailing: Text(data['status'])
                                )
                              ),
                            );
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
