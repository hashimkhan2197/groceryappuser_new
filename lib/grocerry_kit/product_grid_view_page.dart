import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/grocerry_kit/sub_category_grid_view.dart';
import 'package:groceryappuser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:groceryappuser/grocerry_kit/sub_pages/home_list.dart';
import 'package:groceryappuser/providers/category.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:groceryappuser/providers/product.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';


class ProductGridView extends StatefulWidget {
  final String storeDocId;
  final String categoryDocid;
  final String categoryName;
  ProductGridView(this.storeDocId,this.categoryDocid,this.categoryName);
  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          widget.categoryName ,style: TextStyle(color: Colors.white,fontSize: 24)
        ),
        actions: <Widget>[
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
      body: Container(
        child: categoryItems(),
      ),
    );
  }

  Widget categoryItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder(
          stream: Firestore.instance.collection(stores_collection)
              .document(widget.storeDocId)
              .collection(category_collection)
          .document(widget.categoryDocid)
              .collection(products_collection)
              .snapshots(),
          builder: (context,AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final snapShotData = snapshot.data.documents;
            if(snapShotData.length == 0){
              return Center(child: Text("No products added"),);
            }
            return GridView.builder(
                itemCount: snapShotData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                itemBuilder: (context, index) {
                  var data = snapshot.data.documents[index];
                  ProductModel product = Provider.of<Product>(context)
                      .convertToProductModel(data);
                  return Container(
                    width: 130,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return SubcategoryGridView(storeDocId: widget.storeDocId,
                                  categoryDocid: widget.categoryDocid,
                                  productName: product.productName,
                                  subProductDocid: product.productDocId,);
                              }));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              //padding: EdgeInsets.all(10),
                              width: 130,
                              height: 120,
                              alignment: Alignment.bottomCenter,
                              child: Image(
                                fit: BoxFit.cover,
                                //alignment: Alignment.topRight,
                                image:
                                NetworkImage(product.productImageRef),
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
                          if(product.productPrice != '')
                            PriceContainer(product, widget.storeDocId),
                        ]),
                  );
                });
          }
      ),
    );
  }
}
