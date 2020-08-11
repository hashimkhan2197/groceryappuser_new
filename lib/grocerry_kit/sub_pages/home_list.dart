import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/grocerry_kit/store_package/stores_list_screen.dart';
import 'package:groceryappuser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:groceryappuser/providers/category.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/product.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../category_grid_view_Page.dart';
import '../product_grid_view_page.dart';
import '../sub_category_grid_view.dart';

class HomeList extends StatefulWidget {
  HomeList(this.storeDocId);

  final String storeDocId;

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Hexcolor('#0644e3'),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  //HomePage.
                  Navigator.of(context).pushNamed(StoresListPage.routeName);
                },
                child: Text("Change Store",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
            Text(Provider.of<User>(context).userStoreName,
                style: TextStyle(color: Colors.white, fontSize: 24)),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CartPage();
                  }));
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    )
                  ],
                )),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xffF4F7FA),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: FlatButton(
                    onPressed: () {
                      //print(widget.storeDocId);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CategoryGridView(widget.storeDocId);
                      }));
                    },
                    child: Text(
                      'more..',
                      style: TextStyle(color: Hexcolor('#0644e3'),fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            _buildCategoryList(),
            _buildCategoryList2()
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    //var items = addItems();
    return Container(
        height: 190,
        alignment: Alignment.centerLeft,
        child: StreamBuilder(
            stream: Firestore.instance
                .collection(stores_collection)
                .document(widget.storeDocId)
                .collection(category_collection)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  return snapshot.data.documents.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("No categories added."),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length > 3
                              ? 3
                              : snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data.documents[index];
                            var category = Provider.of<Category>(context)
                                .convertToCategoryModel(data);
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 12),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ProductGridView(
                                              widget.storeDocId,
                                              category.categoryDocId,
                                              category.categoryName);
                                        }));
                                      },
                                      child: CircleAvatar(
                                        maxRadius: 70,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        backgroundImage: NetworkImage(
                                            category.categoryImageRef),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          category.categoryName,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ],
                                    )
                                  ]),
                            );
                          },
                        );
              }
            }));
  }

  Widget _buildCategoryList2() {
    //var items = addItems();
    return StreamBuilder(
        stream: Firestore.instance
            .collection(stores_collection)
            .document(widget.storeDocId)
            .collection(category_collection)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              return snapshot.data.documents.length == 0
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("No categories added."),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data.documents[index];
                        var category = Provider.of<Category>(context)
                            .convertToCategoryModel(data);
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 4),
                                  child: Text(
                                    category.categoryName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 4),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ProductGridView(
                                            widget.storeDocId,
                                            category.categoryDocId,
                                            category.categoryName);
                                      }));
                                    },
                                    child: Text(
                                      'more..',
                                      style: TextStyle(
                                          color:
                                              Hexcolor('#0644e3'),fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _buildCategoryProductsList(category.categoryDocId),
                          ],
                        );
                      },
                    );
          }
        });
  }

  Widget _buildCategoryProductsList(String categoryDocId) {
    //var items = addItems();
    return Container(
        height: 270,
        alignment: Alignment.centerLeft,
        child: StreamBuilder(
            stream: Firestore.instance
                .collection(stores_collection)
                .document(widget.storeDocId)
                .collection(category_collection)
                .document(categoryDocId)
                .collection(products_collection)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  return snapshot.data.documents.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("No Products added."),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length > 3
                              ? 3
                              : snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data.documents[index];
                            ProductModel product = Provider.of<Product>(context)
                                .convertToProductModel(data);
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return SubcategoryGridView(
                                          storeDocId: widget.storeDocId,
                                          categoryDocid: categoryDocId,
                                          productName: product.productName,
                                          subProductDocid: product.productDocId,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      //padding: EdgeInsets.all(10),
                                      width: 130,
                                      height: 120,
                                      alignment: Alignment.bottomCenter,
                                      child: Image(
                                        fit: BoxFit.fill,
                                        //alignment: Alignment.topRight,
                                        image: NetworkImage(
                                            product.productImageRef),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 130,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      product.productName,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  if (product.productPrice != '' || product.productPrice == null)
                                    PriceContainer(product, widget.storeDocId),
//                                  if(product.productPrice == "")
//                                    Container(
//                                        width: 130,
//                                        child: GestureDetector(
//                                          onTap: () {
//                                            Navigator.push(context,
//                                                MaterialPageRoute(builder: (context) {
//                                                  return SubcategoryGridView(
//                                                    storeDocId: widget.storeDocId,
//                                                    categoryDocid: categoryDocId,
//                                                    productName: product.productName,
//                                                    subProductDocid: product.productDocId,
//                                                  );
//                                                }));
//                                          },
//                                          child: Container(
//                                            alignment: Alignment.center,
//                                            margin: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
//                                            padding: EdgeInsets.only(top: 4, bottom: 4, left: 5, right: 5),
//                                            //color: Theme.of(context).primaryColor,
//                                            decoration: BoxDecoration(
//                                              color: Theme.of(context).primaryColor,
//                                              shape: BoxShape.rectangle,
//                                              borderRadius: BorderRadius.circular(8),
//                                            ),
//                                            child: Text(
//                                              "Buy",
//                                              style: TextStyle(
//                                                fontSize: 19,
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.bold,
//                                              ),
//                                            ),
//                                          ),
//                                        ))
                                ]);
                          },
                        );
              }
            }));
  }
}

class PriceContainer extends StatefulWidget {
  PriceContainer(this.product, this.storeDocId);

  final String storeDocId;
  final ProductModel product;

  @override
  _PriceContainerState createState() => _PriceContainerState();
}

class _PriceContainerState extends State<PriceContainer> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    UserModel userProfile = Provider.of<User>(context).userProfile;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                " " + widget.product.productPrice + " SEK",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
                  setState(() {
                    _quantity -= 1;
                  });
                },
                icon: Icon(
                  Icons.remove,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Text(
                _quantity.toString(),
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
                  setState(() {
                    _quantity += 1;
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
        Container(
            width: 130,
            child: GestureDetector(
              onTap: () {
                double price = double.parse(widget.product.productPrice);
                Firestore.instance
                    .collection(users_collection)
                    .document(userProfile.userDocId)
                    .collection('cart')
                    .add({
                  'price': price,
                  'image': widget.product.productImageRef,
                  'name': widget.product.productName,
                  'quantity': _quantity,
                  'subtotal': _quantity * price
                }).then((value) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Item added to cart",
                      style: TextStyle(fontSize: 18),
                    ),
                    backgroundColor: Hexcolor('#0644e3'),
                    duration: Duration(milliseconds: 1000),
                  ));
                }).catchError((e) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Error. Please Check your internet connection.",
                      style: TextStyle(fontSize: 18),
                    ),
                    backgroundColor: Theme.of(context).errorColor,
                    duration: Duration(milliseconds: 1000),
                  ));
                });
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 5, right: 5),
                //color: Theme.of(context).primaryColor,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Buy",
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
