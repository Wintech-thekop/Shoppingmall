import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/state/authen.dart';
import 'package:shoppingmall/state/buyer_service.dart';
import 'package:shoppingmall/state/create_account.dart';
import 'package:shoppingmall/state/rider_service.dart';
import 'package:shoppingmall/state/seller/add_product.dart';
import 'package:shoppingmall/state/seller/edit_shop.dart';
import 'package:shoppingmall/state/seller_service.dart';
import 'package:shoppingmall/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/addProduct': (BuildContext context) => AddProduct(),
  '/editShopProfile': (BuildContext context) => EditShopProfile(),
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');

  if (type?.isEmpty ?? true) {
    initialRoute = MyConstant.routeAuthen;
  } else {
    switch (type) {
      case 'Buyer':
        initialRoute = MyConstant.routeBuyerService;
        break;
      case 'Seller':
        initialRoute = MyConstant.routeSellerService;
        break;
      case 'Rider':
        initialRoute = MyConstant.routeRiderService;
        break;
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xffb4004e, MyConstant.mapMaterialColor);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
