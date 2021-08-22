import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  const EditProduct({Key? key, required this.productModel}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  List<String> pathImages = [];
  List<File?> files = [];
  File? file;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    productModel = widget.productModel;
    // print('### image from mySQL ==>> ${productModel!.images}');
    convertStringToArray();
    nameController.text = productModel!.name;
    priceController.text = productModel!.price;
    detailController.text = productModel!.detail;
  }

  void convertStringToArray() {
    String string = productModel!.images;
    // print('string ก่อนตัด ==>> $string');
    string = string.substring(1, string.length - 1);
    // print('string หลังตัด ==>> $string');
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImages.add(item.trim());
      files.add(null);
    }
    print('### pathImages ==>> $pathImages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is Edit Product'),
        actions: [
          IconButton(
            onPressed: () => processEditProduct(),
            icon: Icon(Icons.edit),
            tooltip: 'Edit Product',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle('General :'),
                    buildName(constraints),
                    buildPrice(constraints),
                    buildDetail(constraints),
                    buildTitle('Image Product :'),
                    buildImage(constraints, 0),
                    buildImage(constraints, 1),
                    buildImage(constraints, 2),
                    buildImage(constraints, 3),
                    buildButton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildButton(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth,
          child: ElevatedButton.icon(
            onPressed: () => processEditProduct(),
            icon: Icon(Icons.edit),
            label: Text('Edit Product'),
          ),
        ),
      ],
    );
  }

  Container buildImage(BoxConstraints constraints, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: MyConstant.light)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => processChooseImage(ImageSource.camera, index),
            icon: Icon(Icons.add_a_photo),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            width: constraints.maxWidth * 0.5,
            child: files[index] == null
                ? CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}/shoppingmall/${pathImages[index]}',
                    placeholder: (context, url) => ShowProgress(),
                  )
                : Image.file(files[index]!),
          ),
          IconButton(
            onPressed: () => processChooseImage(ImageSource.gallery, index),
            icon: Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อสินค้าด้วยค่ะ';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: 'Name :',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: priceController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกราคาสินค้าด้วยค่ะ';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: 'Price :',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildDetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            maxLines: 4,
            controller: detailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกรายละเอียดสินค้าด้วยค่ะ';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: 'Detail :',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTitle(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }

  processEditProduct() {
    if (formKey.currentState!.validate()) {
      String name = nameController.text;
      String price = priceController.text;
      String detail = detailController.text;

      print('### name => $name , price => $price ,detail => $detail');
    }
  }

  Future<Null> processChooseImage(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        files[index] = File(result!.path);
      });
    } catch (e) {}
  }
}
