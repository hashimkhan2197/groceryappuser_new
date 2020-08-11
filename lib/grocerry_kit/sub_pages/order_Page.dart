import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryappuser/providers/cart.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/order_model.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';

class OrderPage extends StatefulWidget {
  OrderPage(this.orderSnapshot);

  final DocumentSnapshot orderSnapshot;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  OrderItem _orderItem;
  Color _cartItemColor = Colors.white70;
  double _total = 0;



  @override
  void initState() {
    _orderItem = _covertToOrderItem(widget.orderSnapshot);
    print(_orderItem.cartItemList);
    _total = double.parse(_orderItem.subTotal)+double.parse(_orderItem.deliveryCharges)-double.parse(_orderItem.discPercentage);
    super.initState();
  }

  OrderItem _covertToOrderItem(var snapshot) {
    var data = snapshot.data;
    List<dynamic> cartItemsList = data['products'];
//   List<dynamic> cartItemsList =[];
//   cartItems.forEach((element) {cartItemsList.add(element.values);});
   List<CartItem>  clist= [];
   cartItemsList.forEach((item) { clist.add(CartItem(image: item['productImageRef'],
       price: double.parse(item['productPrice']),
       quantity: int.parse(item['productQuantity']),
       name: item['productName'],
       subTotal: double.parse(item['product'])
   ),);});
    return OrderItem(
        cartItemList:


        clist,
        subTotal: data['subTotal'],
        name: data['name'],
        storeId: data['storeId'],
        storeName: data['storeName'],
        status: data['status'],
        phoneNumber: data['phoneNumber'],
        email: data['email'],
        address: data['Address'],
        dateTime: data['dateTime'],
        deliveryCharges: data['deliveryCharges'],
        deliveryTime: data['deliveryTime'],
        discPercentage: data['discPercentage'],
        extraStuffOrdered: data['extraStuffOrdered'],
        paymentMethod: data['paymentMethod'],
        userUid: data['userUid']
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.dark,
            elevation: 0,
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
            title: Text(
              "Order Details",style: TextStyle(color: Colors.white,fontSize: 24)
            ),

          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
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
                    itemCount: _orderItem.cartItemList.length,
                    itemBuilder: (context, index) {
                      return _listItem(_orderItem.cartItemList[index]);
                    },
                  ),
                ),

                ///Extra stuff column
                Container(
                  width: MediaQuery.of(context).size.width,
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
                    children: <Widget>[Text("Extra Stuff Ordered.",
                      style: TextStyle(fontWeight: FontWeight.w400,
                          fontSize: 17,
                          color: Colors.black),),
                      if (widget.orderSnapshot.data['extraStuffUrl'] != "" && widget.orderSnapshot.data['extraStuffUrl']!=null)
                        Container(
                          margin: EdgeInsets.all(10),
                          //padding: EdgeInsets.all(10),
                          width: 130,
                          height: 130,
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            fit: BoxFit.cover,
                            //alignment: Alignment.topRight,
                            image:
                            NetworkImage(widget.orderSnapshot.data['extraStuffUrl']),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Text(_orderItem.extraStuffOrdered, maxLines: 4,
                        ),
                      ),
                    ],

                  ),
                ),

                ///Column for total price , discount etc
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "Payment Details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Discount: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _orderItem.discPercentage + ' SEK',
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
                            "Sub-Total:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _orderItem.subTotal + " SEK",
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
                            _orderItem.deliveryCharges + " SEK",
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
                            _total.toString()+
                                " SEK",
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


                ///Column for Delivery Timings and Payment Methods
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  padding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            "Delivery Time:",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _orderItem.deliveryTime,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
                            _orderItem.paymentMethod,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),



                ///Column for user details
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    "Customer Details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  padding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                          Text(
                            _orderItem.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
                          Text(
                            _orderItem.phoneNumber,
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
                            "E-Mail:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _orderItem.email,
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
                            "Address:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.all(0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * .6,
                            child: Text(
                              _orderItem.address,
                              maxLines: 7,
                              style: TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///An item in Cart
  Widget _listItem(CartItem cartItem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white70),
      height: 120,
      child: Row(children: <Widget>[
        Container(
          width: 90,
          margin: EdgeInsets.all(10),
          height: 90,
          child: Image.network(
              cartItem.image),
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
                cartItem.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                "Unit Price: " + cartItem.price.toString() + "SEK",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Quantity: " + cartItem.quantity.toString(),
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Subtotal: " + cartItem.subTotal.toString() + " SEK",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  ///place order Function
  Future<void> _updateOrder(List<CartItem> cartItemList,
      UserModel userProfile) async {
    DateTime timestamp = DateTime.now();

    try {
      await Firestore.instance.collection(orders_Collection).add({
        'status': 'Pending',
      });
    } on PlatformException catch (err) {
      var message = "An error has occured, please check your internet connection.";

//      if (err.message != null) {
//        message = err.message;
//      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Colors.red,
      ));

//      setState(() {
//        _isLoading = false;
//      });
    } catch (err) {
      print(err);
      var message = "An error has occured, please check your internet connection.";
//      if (err.message != null) {
//        message = err.message;
//      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Colors.red,
      ));
//      setState(() {
//        _isLoading = false;
//      });
    }
  }
}
