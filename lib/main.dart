import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryappuser/grocerry_kit/SignIn.dart';
import 'package:groceryappuser/providers/cart.dart';
import 'package:groceryappuser/providers/category.dart';
import 'package:groceryappuser/providers/product.dart';
import 'package:groceryappuser/providers/store.dart';
import 'package:groceryappuser/providers/user.dart';
import 'package:groceryappuser/splash_screen.dart';
import 'package:provider/provider.dart';
import 'grocerry_kit/store_package/stores_list_screen.dart';
import 'grocerry_kit/sub_pages/cartPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Store(),
        ),
        ChangeNotifierProvider.value(
          value: Category(),
        ),
        ChangeNotifierProvider.value(
          value: Product(),
        ),
        ChangeNotifierProvider.value(
          value: User(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grocery App',
        theme: ThemeData(
primaryColor: Colors.amber,
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
        ),
        home: SplashScreen(),

        routes: {
          SignInPage.routeName: (context) => SignInPage(),
          StoresListPage.routeName: (context) => StoresListPage(),
          },
      ),
    );
  }
}
