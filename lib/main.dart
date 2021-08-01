import 'package:flutter/material.dart';
import 'package:shoppingmall/state/authen.dart';
import 'package:shoppingmall/state/buyer_service.dart';
import 'package:shoppingmall/state/create_account.dart';
import 'package:shoppingmall/state/rider_service.dart';
import 'package:shoppingmall/state/saler_service.dart';
import 'package:shoppingmall/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/salerService': (BuildContext context) => SalerService(),
};

String? initialRoute;

void main() {
  initialRoute = MyConstant.routeAuthen;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
