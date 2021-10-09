import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/models/sqlite_model.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/sqlite_helper.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModel;
  const ShowProductBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowProductBuyerState createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModel;
  bool load = true;
  bool? haveData;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int imageIndex = 0;
  int amountCount = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readAPI();
  }

  Future<void> readAPI() async {
    String urlAPI =
        '${MyConstant.domain}/shoppingmall/getProductWhereIdSeller.php?isAdd=true&idSeller=${userModel!.id}';
    await Dio().get(urlAPI).then((value) {
      //  print('### value = $value');

      if (value.toString() == 'null') {
        setState(() {
          haveData = false;
          load = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);

          String string = model.images;
          string = string.substring(1, string.length - 1);
          List<String> strings = string.split(',');
          int index = 0;
          for (var item in strings) {
            strings[index] = item.trim();
            index++;
          }
          listImages.add(strings);

          setState(() {
            haveData = true;
            load = false;
            productModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? listProduct()
              : Center(
                  child: ShowTitle(
                    title: 'No product',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
    );
  }

  LayoutBuilder listProduct() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            showAlertDialog(productModels[index], listImages[index]);
            //           amountCount = 1;
          },
          child: Card(
            child: Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.5 - 8,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: findUrlImage(productModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.image1),
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.5,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTitle(
                            title: productModels[index].name,
                            textStyle: MyConstant().h2Style()),
                        ShowTitle(
                            title: 'Price : ${productModels[index].price} THB',
                            textStyle: MyConstant().h3Style()),
                        ShowTitle(
                            title: cutWord(
                                'Detail : ${productModels[index].detail}'),
                            textStyle: MyConstant().h3Style()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String findUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    return '${MyConstant.domain}/shoppingmall/${strings[0]}';
  }

  Future<void> showAlertDialog(
      ProductModel productModel, List<String> images) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: ListTile(
            leading: ShowImage(path: MyConstant.image3),
            title: ShowTitle(
              title: productModel.name,
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: ShowTitle(
              title: 'Price : ${productModel.price} THB',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      '${MyConstant.domain}/shoppingmall/${images[imageIndex]}',
                  placeholder: (context, url) => ShowProgress(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            imageIndex = 0;
                            print('imageIndex = $imageIndex');
                          });
                        },
                        icon: Icon(Icons.filter_1),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            imageIndex = 1;
                            print('imageIndex = $imageIndex');
                          });
                        },
                        icon: Icon(Icons.filter_2),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            imageIndex = 2;
                            print('imageIndex = $imageIndex');
                          });
                        },
                        icon: Icon(Icons.filter_3),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            imageIndex = 3;
                            print('imageIndex = $imageIndex');
                          });
                        },
                        icon: Icon(Icons.filter_4),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ShowTitle(
                        title: 'รายละเอียด (Detail) :',
                        textStyle: MyConstant().h2Style()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 230,
                        child: ShowTitle(
                            title: productModel.detail,
                            textStyle: MyConstant().h3Style()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  amountAddRemove(setState),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (amountCount >= 2) {
                          setState(() {
                            amountCount--;
                          });
                        }
                      },
                      icon: Icon(Icons.remove_circle_outline),
                      color: MyConstant.dark,
                    ),
                    ShowTitle(
                      title: amountCount.toString(),
                      textStyle: MyConstant().h1Style(),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          amountCount++;
                        });
                      },
                      icon: Icon(Icons.add_circle_outline),
                      color: MyConstant.dark,
                    ),
                  ],
                ),
                //addCartOrCancel(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        //       Navigator.pop(context);
                        String idSeller = userModel!.id;
                        String idProduct = productModel.id;
                        String name = productModel.name;
                        String price = productModel.price;
                        String amount = amountCount.toString();
                        String sum =
                            (int.parse(price) * amountCount).toString();
                        print(
                            ' IdSeller ==> $idSeller , IdProduct ==> $idProduct , Name ==> $name , Price ==> $price , Amount ==> $amount , sum ==> $sum');
                        SQLiteModel sqLiteModel = SQLiteModel(
                            idSeller: idSeller,
                            idProduct: idProduct,
                            name: name,
                            price: price,
                            amount: amount,
                            sum: sum);
                        await SQLiteHelper()
                            .insertValueToSQLite(sqLiteModel)
                            .then((value) {
                          amountCount = 1;
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        'Add Cart',
                        style: MyConstant().h2GreenStyle(),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        amountCount = 1;
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: MyConstant().h2RedStyle(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String cutWord(String string) {
    String result = string;
    if (result.length >= 100) {
      result = result.substring(0, 100);
      result = '$result ...';
    }
    return result;
  }
}
