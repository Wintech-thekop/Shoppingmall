import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_progress.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  _ShowProductSellerState createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValuefromAPI();
  }

  Future<Null> loadValuefromAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/shoppingmall/getProductWhereIdSeller.php?isAdd=true&idSeller=$id';

    await Dio().get(apiGetProductWhereIdSeller).then((value) {
      print('value ==> $value');
      for (var item in json.decode(value.data)) {
        ProductModel model = ProductModel.fromMap(item);
        print('Name product ===> ${model.name}');
        setState(() {
          load = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load ? ShowProgress() : Text('Load Data Finish'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct),
        child: Text(
          'Add',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
