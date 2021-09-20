import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class ShowAllShop extends StatefulWidget {
  const ShowAllShop({Key? key}) : super(key: key);

  @override
  _ShowAllShopState createState() => _ShowAllShopState();
}

class _ShowAllShopState extends State<ShowAllShop> {
  @override
  void initState() {
    super.initState();
    readApiAllShop();
  }

  Future<Null> readApiAllShop() async {
    String urlAPI = "${MyConstant.domain}/shoppingmall/getUserWhereSeller.php";
    await Dio().get(urlAPI).then((value) {
      // print('value ===> $value');
      var result = json.decode(value.data);
      // print('result ===> $result');
      for (var item in result) {
        // print('item ===> $item');
        UserModel model = UserModel.fromMap(item);
        print('name ===> ${model.name}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Show all shop'),
    );
  }
}
