import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class EditShopProfile extends StatefulWidget {
  // final UserModel userModel;
  const EditShopProfile({Key? key}) : super(key: key);

  @override
  _EditShopProfileState createState() => _EditShopProfileState();
}

class _EditShopProfileState extends State<EditShopProfile> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user = preferences.getString('user')!;

    String apiGetUser =
        '${MyConstant.domain}/shoppingmall/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiGetUser).then((value) {
      print('value ==> $value');

      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameController.text = userModel!.name;
          addressController.text = userModel!.address;
          phoneController.text = userModel!.phone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('This is Edit Shop profile'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
              tooltip: 'Edit Shop profile',
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => ListView(
            padding: EdgeInsets.all(16),
            children: [
              ShowTitle(title: 'General', textStyle: MyConstant().h2Style()),
              buildName(constraints),
              buildAddress(constraints),
              buildPhone(constraints),
            ],
          ),
        ));
  }

Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone :',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            maxLines: 3,
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address :',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Shop Name :',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
