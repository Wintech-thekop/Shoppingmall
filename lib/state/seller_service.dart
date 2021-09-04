import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/state/seller/show_order_seller.dart';
import 'package:shoppingmall/state/seller/show_product_seller.dart';
import 'package:shoppingmall/state/seller/show_shop_seller.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_signout.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  _SellerServiceState createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## Login id ==>> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ==>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          print('### Login name ==> ${userModel!.name}');

          widgets.add(ShowOrderSeller());
          widgets.add(ShowShopSeller(userModel: userModel!));
          widgets.add(ShowProductSeller());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Service'),
      ),
      drawer: widgets.length == 0 ? SizedBox() : Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                buildHeader(),
                showOrder(),
                showShop(),
                showProduct(),
              ],
            )
          ],
        ),
      ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHeader() {
    return UserAccountsDrawerHeader(
      otherAccountsPictures: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.face_outlined),
          iconSize: 36,
          color: MyConstant.light,
          tooltip: 'Edit Shop Profile',
        ),
      ],
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [MyConstant.light, MyConstant.dark],
          center: Alignment(-0.8, -0.2),
          radius: 1,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage:
            NetworkImage('${MyConstant.domain}${userModel!.avatar}'),
      ),
      accountName: Text(
        userModel == null ? 'name ?' : userModel!.name,
        style: MyConstant().h2WhiteStyle(),
      ),
      accountEmail: Text(userModel == null ? 'Type ?' : userModel!.type),
    );
  }

  ListTile showOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.filter_1_outlined,
        color: Colors.pink,
      ),
      title: ShowTitle(
        title: 'Show Order',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายการสั่งซื้อ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile showShop() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.filter_2_outlined,
        color: Colors.pink,
      ),
      title: ShowTitle(
        title: 'Show Shop Profile',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงหน้าร้านให้ลูกค้าเห็น',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile showProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.filter_3_outlined,
        color: Colors.pink,
      ),
      title: ShowTitle(
        title: 'Show Product',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงสินค้าและโปรโมชั่น',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
