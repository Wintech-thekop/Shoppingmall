import 'package:flutter/material.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowShopSeller extends StatefulWidget {
  final UserModel userModel;
  const ShowShopSeller({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowShopSellerState createState() => _ShowShopSellerState();
}

class _ShowShopSellerState extends State<ShowShopSeller> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowTitle(title: 'Name Shop :', textStyle: MyConstant().h2Style()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShowTitle(
                      title: userModel!.name, textStyle: MyConstant().h1Style()),
                ),
              ],
            ),
            ShowTitle(title: 'Address:', textStyle: MyConstant().h2Style()),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: constraints.maxWidth * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShowTitle(
                        title: userModel!.address, textStyle: MyConstant().h2Style()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
