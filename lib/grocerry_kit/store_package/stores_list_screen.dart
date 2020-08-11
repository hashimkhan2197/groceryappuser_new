import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/store.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';

class StoresListPage extends StatefulWidget {
  static const routeName = "/StoresList";

  @override
  _StoresListPageState createState() => _StoresListPageState();
}

class _StoresListPageState extends State<StoresListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Stores",style: TextStyle(color: Colors.white,fontSize: 24)
        ),
        backgroundColor: Hexcolor('#0644e3'),
      ),
      //bottomNavigationBar: BottomBar(),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
//            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  "Choose your favourite grocery store or the one nearest to you.",
                  maxLines: 4,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Expanded(
                child: StreamBuilder(
                    stream:
                        Firestore.instance.collection(stores_collection).snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                          break;
                        default:
                          if (snapshot.data.documents.length > 0) {
                            return ListView.builder(

                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = snapshot.data.documents[index];
                                return _vehicleCard(data);
                              },
                              itemCount: snapshot.data.documents.length,
                            );
                          }
                          return Center(
                            child: Text("No Stores Added"),
                          );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleCard(DocumentSnapshot storeSnapshot) {
    StoreModel store =
        Provider.of<Store>(context).convertToStoreModel(storeSnapshot);
    UserModel userProfile = Provider.of<User>(context).userProfile;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async{
          await Firestore.instance
              .collection(users_collection)
              .document(userProfile.userDocId)
              .collection('cart')
              .getDocuments()
              .then((QuerySnapshot snapshot) {
            for (DocumentSnapshot doc in snapshot.documents) {
              doc.reference.delete();
            }
          }).catchError((e){
            print(e);
          });

          Provider.of<User>(context, listen: false)
              .setUserStoreId(
              storeDocId: store.storeDocId,
              storeName: store.storeName,
              storeId: store.storeId)
              .then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage(storeName: store.storeName,storeDocId: store.storeDocId,)),
            );
          });
        },
        child: Container(
          child: new FittedBox(
            child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0x802196F3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: myDetailsContainer1(store),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      child: store.storeImageRef != null
                          ? ClipRRect(
                              borderRadius: new BorderRadius.circular(24.0),
                              child: Image(
                                fit: BoxFit.contain,
                                alignment: Alignment.topRight,
                                image: NetworkImage(store.storeImageRef),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(right: 25),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.navigate_next,
                                size: 50,
                              ),
                            ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(StoreModel docu) {
    StoreModel doc = docu;
    return LimitedBox(
      //maxHeight: 200,
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Container(
//                alignment: Alignment.centerRight,
//                child: IconButton(
//                  icon: Icon(Icons.edit),
//                  onPressed: () {},
//                  iconSize: 30,
//                )),
            Container(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                doc.storeName,
                maxLines: 3,
                style: TextStyle(
                    color: Color(0xffe6020a),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: Text(
                doc.storeAddress,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
