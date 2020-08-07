import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryappuser/grocerry_kit/product_grid_view_page.dart';
import 'package:groceryappuser/providers/category.dart';
import 'package:groceryappuser/providers/collection_names.dart';
import 'package:provider/provider.dart';


class CategoryGridView extends StatefulWidget {
  final String storeDocId;
  CategoryGridView(this.storeDocId);
  @override
  _CategoryGridViewState createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          'All Categories' ,style: TextStyle(color: Colors.white,fontSize: 24)
        ),
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
              .document(widget.storeDocId).collection(category_collection)
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
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  var data = snapShotData[index];
                  var category = Provider.of<Category>(context)
                      .convertToCategoryModel(data);
                  return Padding(
                    padding:
                    const EdgeInsets.only(left: 16.0, top: 12),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return ProductGridView(
                                      widget.storeDocId,category.categoryDocId,
                                      category.categoryName
                                    );
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                category.categoryName+" ",
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
                });
          }
      ),
    );
  }
}
