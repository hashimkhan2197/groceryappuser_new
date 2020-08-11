import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryappuser/providers/cart.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:groceryappuser/widgets/custom_image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../style_functions.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  StyleFunctions formFieldStyle = StyleFunctions();
  TextEditingController _couponCodeController = TextEditingController();
  TextEditingController _extraStuffController = TextEditingController();
  bool promoCodeChecker = true;
  double _discountPercentage = 0;
  double _discount = 0;
  double _deliveryCharges = 0;
  double _subtotal = 0;
  double _total = 0;
  Color _cartItemColor = Colors.white70;
  String _extraStuffUrl = "";

  File _productImageFile;
  void _pickedImage(File image) {
    _productImageFile = image;
  }

  @override
  void dispose() {
    _couponCodeController.dispose();
    _extraStuffController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userProfile =
        Provider
            .of<User>(context, listen: false)
            .userProfile;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          brightness: Brightness.dark,
          elevation: 0,
          backgroundColor: Hexcolor('#0644e3'),
          automaticallyImplyLeading: false,
          title: Text(
            'Cart',
            style: TextStyle(color: Colors.white,fontSize: 24),
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: Firestore.instance.collection(users_collection)
              .document(userProfile.userDocId).collection('cart').snapshots(),
          builder: (context,AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final snapShotData = snapshot.data.documents;
            if(snapShotData.length == 0){
              return Center(child: Text("Cart is empty.",style:TextStyle(color: Hexcolor('#0644e3'),fontSize: 30)),);
            }
            if (snapShotData.length > 0) {
              _subtotal = 0;
              snapShotData.forEach((element) {
                _subtotal += element.data['price']*element.data['quantity'];

              });

              if (_subtotal < 100) {
                _deliveryCharges = double.parse(Provider.of<User>(context).first);
              } else if (_subtotal < 200) {
                _deliveryCharges = double.parse(Provider.of<User>(context).second);
              } else if (_subtotal > 200) {
                _deliveryCharges = double.parse(Provider.of<User>(context).third);
              }


              _total = _subtotal - (_subtotal * _discountPercentage * 0.01);
              _discount = _subtotal - _total;
              _total = _total + _deliveryCharges;

            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),

                  ///List of Products
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16, top: 4),
                    child: Text(
                      "Cart Products",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white70),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .55,
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapShotData.length,
                      itemBuilder: (context, index) {

                        return _listItem(snapShotData[index]);
                      },
                    ),
                  ),

                  ///Cancel Order Buttons
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text('Remove All Items',
                          style: TextStyle(fontSize: 20, color: Hexcolor('#0644e3'))),
                      onPressed: () async {
//                        setState(() {
//                          _isLoading = true;
//                        });
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
//                            _isLoading = false;
                          });
//                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                  ///Extra stuff column
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    padding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Do you want to add anything else that is not mentioned here and you know its in the store?\nDon't worry, we will get it to you! :)",
                          maxLines: 5,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        UserImagePicker(_pickedImage),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          child: TextField(
                            controller: _extraStuffController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration:
                            formFieldStyle.formTextFieldDecoration(
                                "Enter your order here"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Column for total price , discount etc
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    padding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
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
                              "Add Coupon:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .35,
//                      padding: EdgeInsets.only(
//                          left: 16, right: 16, top: 8, bottom: 8),
                              child: TextField(
                                controller: _couponCodeController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Code',
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
                            FlatButton(
                              onPressed: () {
                                if (_couponCodeController.text
                                    .trim()
                                    .isNotEmpty) {
                                  Firestore.instance
                                      .collection(discount_coupons_collection)
                                      .where('promoCode',
                                      isEqualTo: _couponCodeController
                                          .text
                                          .trim())
                                      .getDocuments()
                                      .then((value) {
                                    if (value.documents.length > 0) {
                                      setState(() {
                                        _discountPercentage = double.parse(
                                            value.documents[0]
                                                .data['discPercentage']);
                                        promoCodeChecker = true;
                                        _couponCodeController.clear();
                                      });
                                    } else {
                                      setState(() {
                                        promoCodeChecker = false;
                                        _couponCodeController.clear();
                                      });
                                    }
                                  });
                                }
                              },
                              child: Text(
                                "Apply",
                                style: TextStyle(color: Hexcolor('#0644e3')),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        if (promoCodeChecker == false)
                          Text(
                            "No such promo cade available",
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(
                          height: 6,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Sub-Total:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _subtotal.toString() + " SEK",
                              style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        if (_discountPercentage > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "You have saved: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _discount.toStringAsFixed(2)+" SEK",
                                style: TextStyle(
                                  fontSize: 18,
                                  //fontWeight: FontWeight.w500,
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
                              "Delivery Charges:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _deliveryCharges.toString() + " SEK",
                              style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.w500,
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
                              "Total:",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _total.toStringAsFixed(2) + " SEK",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Hexcolor('#0644e3'),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    width: 250,
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Proceed To Checkout',
                              style: TextStyle(fontSize: 20, color: Colors.white)),Icon(Icons.arrow_forward_ios,color: Colors.white,size: 20,)
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CheckoutPage(deliveryCharges: _deliveryCharges,
                          discountPercentage:_discount ,
                          extraStuffOrdered: _extraStuffController.text,
                            extraStuffFile: _productImageFile,
                            subtotal: _subtotal,
                          total: _total,
                          );
                        }));
                      },
                    ),
                  ),

                ],
              ),
            );
          }
        ),
      ),
    );
  }

  ///An item in Cart
  Widget _listItem(DocumentSnapshot item) {
    UserModel userProfile= Provider.of<User>(context,listen: false).userProfile;
    var cartItem = item.data;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white70),
      height: 165,
      child: Row(children: <Widget>[
        Container(
          width: 90,
          margin: EdgeInsets.all(10),
          height: 90,
          child: Image.network(cartItem['image']),
          decoration: BoxDecoration(),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                cartItem['name'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              Text(
                "Unit Price: " + cartItem['price'].toString() + "SEK",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Quantity: ",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 130,
                    child: Row(
                      //mainAxisSize: MainAxisSize.,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            //cartItem['quantity']+=1;

                             Firestore.instance.collection(users_collection).document(userProfile.userDocId)
                                 .collection('cart').document(item.documentID)
                                 .updateData({
                               'quantity': cartItem['quantity']-1
                             });

                          },
                          icon: Icon(
                            Icons.remove,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                        Text(
                          cartItem['quantity'].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                        IconButton(
                          //alignment: Alignment.center,

                          onPressed: () {

                              Firestore.instance.collection(users_collection).document(userProfile.userDocId)
                                  .collection('cart').document(item.documentID)
                                  .updateData({
                                'quantity': cartItem['quantity']+1
                              });

                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                "Subtotal: " + (cartItem['price']*cartItem['quantity']).toString() + " SEK",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(onTap: (){
                Firestore.instance.collection(users_collection).document(userProfile.userDocId)
                    .collection('cart').document(item.documentID)
                    .delete();
              },
                child: Row(
                  children: <Widget>[
                    Text(
                      'remove ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.delete_forever,color:Colors.red,size: 25,),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

}
