import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  _ShowProductSellerState createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveData;

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
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have Data
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('Name product ===> ${model.name}');
          setState(() {
            load = false;
            haveData = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'Have Data',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                        title: 'You can add more data',
                        textStyle: MyConstant().h2Style(),
                      ),
                    ],
                  ),
              )
              : Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'Have No Data',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                        title: 'Please add any data',
                        textStyle: MyConstant().h2Style(),
                      ),
                    ],
                  ),
              ),
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
