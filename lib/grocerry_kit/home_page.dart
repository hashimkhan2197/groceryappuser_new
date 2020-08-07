import 'package:flutter/material.dart';
import 'package:groceryappuser/grocerry_kit/feedback_page.dart';
import 'package:groceryappuser/grocerry_kit/profile.dart';
import 'package:groceryappuser/grocerry_kit/store_package/stores_list_screen.dart';
import 'package:groceryappuser/grocerry_kit/sub_pages/order_history.dart';
import 'package:groceryappuser/utils/cart_icons_icons.dart';

import 'help_Page.dart';
import 'sub_pages/cartPage.dart';
import 'sub_pages/home_list.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  static const routeName = "/storeHomepage";

  HomePage({this.storeDocId,this.storeName});
  String storeDocId ;
  String storeName;
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  //NavigationBarFunctions navigationBarFunctions = NavigationBarFunctions();
  List<Widget> _widgetList ;
  @override
  void initState() {
    _widgetList = [
    HomeList(widget.storeDocId),
    CartPage(),
    OrderHistory(),
    MyProfile()];
    super.initState();
  }

  final controller = PageController(
      initialPage: 0,keepPage: true);
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _buildAppBar(),
      //bottomNavigationBar: _buildBottomNavigationBar(),
      body: PageView(controller: controller,
      children: <Widget>[
        HomeList(widget.storeDocId),
        CartPage(),OrderHistory(),MyProfile(),FeedbackPage(),HelpPage()
      ],),
    );
  }

  Widget _buildBottomNavigationBar(){

    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.shifting,
      currentIndex: _index,
      onTap: (index) {
        setState(() {
          _index = index;

        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              CartIcons.home,
              color: Colors.black,
            ),
            title: Text('   Store  ', style: TextStyle())),
        BottomNavigationBarItem(
            icon: Icon(
              CartIcons.cart,
            ),
            title: Text('My Cart', style: TextStyle())),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            title: Text('History', style: TextStyle())),
        BottomNavigationBarItem(
            icon: Icon(
              CartIcons.account,
            ),
            title: Text(
              'My Account',
              style: TextStyle(),
            ))
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      title: Text(
        widget.storeName,
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(StoresListPage.routeName);
            },
            child: Row(
              children: <Widget>[Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: Text("Change Store"),
              )],
            ))
      ],
    );
  }
}



