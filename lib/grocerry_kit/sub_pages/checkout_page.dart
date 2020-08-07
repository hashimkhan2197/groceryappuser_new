import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryappuser/providers/cart.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final double discountPercentage;
  final double deliveryCharges;
  final double subtotal;
  final double total;
  final String extraStuffOrdered;
  final File extraStuffFile;

  CheckoutPage(
      {@required this.discountPercentage,
      @required this.deliveryCharges,
      @required this.subtotal,
      @required this.total,
      @required this.extraStuffOrdered,
      @required this.extraStuffFile});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _selectPaymentMethod = false;
  String _paymentMethod = '';
  bool _isLoading = false;
  Color _cartItemColor = Colors.white70;
  String _deliveryTime = "";
  bool _scheduleDeliveryTime = false;
  bool _selectDelivery = false;
  bool _orderSuccessful = false;


  TextEditingController _addressController;
  TextEditingController _numberController;
  TextEditingController _nameController;
  TextEditingController _emailController;

  @override
  void dispose() {
    _emailController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userProfile =
        Provider.of<User>(context, listen: false).userProfile;
    List<CartItem> cartItemList =
        Provider.of<Cart>(context, listen: false).getCartItemList();
    _addressController = TextEditingController(text: userProfile.address);
    _nameController = TextEditingController(text: userProfile.name);
    _numberController = TextEditingController(text: userProfile.phoneNumber);
    _emailController = TextEditingController(text: userProfile.email);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.blue,
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
        title: Text('Checkout',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: _orderSuccessful == true
          ? Center(
              child: Text(
                "Order Placed Successfully",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ///Column for Delivery Timings
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: _cartItemColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //Row to show delivery time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Delivery Time:",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _deliveryTime,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        //Delivery timings buttons hours
                        if (_selectDelivery == false)
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                //_deliveryTime = snapshot.data.documents[index].data['deliveryTime'];
                                _scheduleDeliveryTime = false;
                                _selectDelivery = true;

                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Select Delivery Time",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                            ),
                          ),

                        if (_selectDelivery == true)
                          Container(
//                            height: 50,
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection(delivery_timings_collection)
                                  .where('status', isEqualTo: 'active').orderBy('deliveryTime')
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
                                    break;
                                  default:
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
//                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          return FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                _deliveryTime = snapshot
                                                    .data
                                                    .documents[index]
                                                    .data['deliveryTime'];
                                                _selectDelivery = false;
                                                _scheduleDeliveryTime = false;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Delivery within "+
                                                snapshot.data.documents[index]
                                                    .data["deliveryTime"],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context).primaryColor),
                                              ),
                                            ),
                                          );
                                        });
                                }
                              },
                            ),
                          ),
                        //delivery time buttons schedule
                        if(_scheduleDeliveryTime == false)
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                //_deliveryTime = snapshot.data.documents[index].data['deliveryTime'];
                                _scheduleDeliveryTime = true;
                                _selectDelivery = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Schedule your own Delivery",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                        if (_scheduleDeliveryTime == true)
                          Container(
                            height: 300,
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection(delivery_schedule_collection)
                                  .where('status', isEqualTo: 'active').orderBy('t')
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
                                    break;
                                  default:
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        //scrollDirection: Axis.horizontal,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            alignment: Alignment.centerLeft,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  _deliveryTime = snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['deliveryTime'];
                                                  _scheduleDeliveryTime = false;
                                                  _selectDelivery = false;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text("From: "+
                                                  snapshot.data.documents[index]
                                                      .data["deliveryTime"],
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500,
                                                      color: Theme.of(context).primaryColor),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                }
                              },
                            ),
                          )
                      ],
                    ),
                  ),

                  ///Column for Payment Methods
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: _cartItemColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //Row to show delivery time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Payment Method:",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _paymentMethod,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        ///Payment Method Buttons
                        if (_selectPaymentMethod == false)
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                //_deliveryTime = snapshot.data.documents[index].data['deliveryTime'];
                                _selectPaymentMethod = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Select Payment Method",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                        if (_selectPaymentMethod == true)
                          Container(
                            alignment: Alignment.centerLeft,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  _paymentMethod = "Cash On Delivery";
                                  _selectPaymentMethod = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Cash On Delivery",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                        if (_selectPaymentMethod == true)
                          Container(
                            alignment: Alignment.centerLeft,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  _paymentMethod = "Swipe On Delivery";
                                  _selectPaymentMethod = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Swipe On Delivery",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  ///Column for user details
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: _cartItemColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Name:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width * .6,
                              child: TextField(
                                maxLines: 1,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Number:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width * .6,
                              child: TextField(
                                maxLines: 1,
                                controller: _numberController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "E-Mail:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width * .6,
                              child: TextField(
                                maxLines: 2,
                                controller: _emailController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Address:",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width * .6,
                              child: TextField(
                                maxLines: 5,
                                controller: _addressController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///Order Buttons
                  _isLoading == true
                      ? CircularProgressIndicator()
                      : Container(
                          margin: EdgeInsets.only(top: 16, bottom: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          width: 150,
                          child: FlatButton(
                            child: Text('Order Now',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              if(_deliveryTime == ""){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    "Please select a delivery time.",
                                  ),
                                  backgroundColor: Colors.blue,
                                ));
                              }else if(_paymentMethod == ""){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    "Please select a payment method."
                                  ),
                                  backgroundColor: Colors.blue,
                                ));
                              }
                              if (_deliveryTime != "" && _paymentMethod != "") {
                                _addOrder(userProfile).then((value) {
                                  setState(() {
                                    _orderSuccessful = true;
                                  });
                                }).catchError((err) {
                                  setState(() {
                                    _isLoading = false;
                                    _orderSuccessful = false;
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "An error has occured,Please try Later"),
                                    backgroundColor: Colors.red,
                                  ));
                                });
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                        ),

                  ///Cancel Order Buttons
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    width: 150,
                    child: FlatButton(
                      child: Text('Cancel Order',
                          style: TextStyle(fontSize: 20, color: Colors.grey)),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await Firestore.instance
                            .collection(users_collection)
                            .document(userProfile.userDocId)
                            .collection('cart')
                            .getDocuments()
                            .then((QuerySnapshot snapshot) {
                          for (DocumentSnapshot doc in snapshot.documents) {
                            doc.reference.delete();
                          }
                        }).then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  ///place order Function
  Future<void> _addOrder(UserModel userProfile) async {
    QuerySnapshot cartItems;
    await Firestore.instance
        .collection(users_collection)
        .document(userProfile.userDocId)
        .collection('cart')
        .getDocuments()
        .then((QuerySnapshot value) {
      cartItems = value;
    });
    DateTime timestamp = DateTime.now();
    var url="";
    if(widget.extraStuffFile!= null){
      final ref =
      FirebaseStorage.instance.ref().child('images').child(DateTime.now().toString()+ ".jpg");
      await ref.putFile(widget.extraStuffFile).onComplete;

      url = await ref.getDownloadURL();
    }


    try {
      await Firestore.instance.collection(orders_Collection).add({
        'storeId': Provider.of<User>(context, listen: false).userStoreId,
        'storeName': Provider.of<User>(context, listen: false).userStoreName,
        'status': 'Pending',
        'name': _nameController.text,
        'phoneNumber': _numberController.text,
        "Address": _addressController.text,
        "email": _emailController.text,
        "userUid": userProfile.userDocId,
        'deliveryCharges': widget.deliveryCharges.toString(),
        'subTotal': widget.subtotal.toString(),
        'discPercentage': widget.discountPercentage.toString(),
        'deliveryTime': _deliveryTime,
        'dateTime': timestamp.toIso8601String(),
        'completed': false,
        'paymentMethod': _paymentMethod,
        'extraStuffOrdered': widget.extraStuffOrdered,
        'extraStuffUrl': url,
        'products': cartItems.documents
            .map((DocumentSnapshot cp) => {
                  'productName': cp.data['name'],
                  'productImageRef': cp.data['image'],
                  'productQuantity': cp.data['quantity'].toString(),
                  'productPrice': cp.data['price'].toString(),
                  "product": cp.data['subtotal'].toString(),
                })
            .toList(),
      });
      await Firestore.instance
          .collection(users_collection)
          .document(userProfile.userDocId)
          .collection('cart')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
        }
      });
    } catch (err) {
      print(err);
      var message =
          "An error has occured, please check your internet connection.";
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }
}
