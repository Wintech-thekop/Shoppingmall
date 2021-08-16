import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/main.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDetailController = TextEditingController();
  List<String> paths = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => processAddProduct(),
            icon: Icon(Icons.cloud_upload),
          ),
        ],
        title: Text('This is Add Order'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildAddProductName(constraints),
                    buildAddProductPrice(constraints),
                    buildAddProductDetail(constraints),
                    biuldImage(constraints),
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

  Container buildButton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        onPressed: () {
          processAddProduct();
        },
        child: Text('Add Product'),
        style: MyConstant().myButtonStyle(),
      ),
    );
  }

  Future<Null> processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        //       print('### Select 4 images success');
        MyDialog().showProgressDialog(context);
        String apiSaveProduct =
            '${MyConstant.domain}/shoppingmall/saveProduct.php';

        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(1000000);
          String nameFile = 'product$i.jpg';

          paths.add('/product/$nameFile');

          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);

          await Dio().post(apiSaveProduct, data: data).then(
            (value) async {
              print('### Upload success');
              loop++;
              if (loop >= files.length) {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();

                String idSeller = preferences.getString('id')!;
                String nameSeller = preferences.getString('name')!;
                String name = productNameController.text;
                String price = productPriceController.text;
                String detail = productDetailController.text;
                String images = paths.toString();
                print('### idSeller = $idSeller, nameSeller = $nameSeller');
                print('### name = $name, price q= $price, detail = $detail');
                print('### images ==> $images');

                String path =
                    '${MyConstant.domain}/shoppingmall/insertProduct.php?isAdd=true&idSeller=$idSeller&nameSeller=$nameSeller&name=$name&price=$price&detail=$detail&images=$images';

                await Dio().get(path).then((value) => Navigator.pop(context));

                Navigator.pop(context);
              }
            },
          );
        }
      } else {
        MyDialog().normalDialog(
            context, 'รูปภาพสินค้าไม่ครบ', 'กรุณาเลือรูปสินค้าให้ครบด้วยค่ะ');
      }
    }
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> chooseSourseImageDialog(int index) async {
    print('You click image ==> $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image4),
          title: ShowTitle(
            title: 'Source Image ${index + 1} ?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: 'กรุณาเลือกรูปภาพจาก Camera หรือ Gallery',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column biuldImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.75,
          child:
              file == null ? Image.asset(MyConstant.image5) : Image.file(file!),
        ),
        Container(
          width: constraints.maxWidth * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: constraints.maxWidth * 0.17,
                height: constraints.maxWidth * 0.17,
                child: InkWell(
                  onTap: () => chooseSourseImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(
                          files[0]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.17,
                height: constraints.maxWidth * 0.17,
                child: InkWell(
                  onTap: () => chooseSourseImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(
                          files[1]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.17,
                height: constraints.maxWidth * 0.17,
                child: InkWell(
                  onTap: () => chooseSourseImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(
                          files[2]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.17,
                height: constraints.maxWidth * 0.17,
                child: InkWell(
                  onTap: () => chooseSourseImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(
                          files[3]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAddProductName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: productNameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อสินค้าด้วยค่ะ';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'New Product... :',
          prefixIcon: Icon(
            Icons.production_quantity_limits,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget buildAddProductPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: productPriceController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกราคาสินค้าด้วยค่ะ';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'New Product Price... :',
          prefixIcon: Icon(
            Icons.money_sharp,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget buildAddProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: productDetailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกรายละเอียดสินค้าด้วยค่ะ';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          hintStyle: MyConstant().h3Style(),
          hintText: 'New Product Detail... :',
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: Icon(
              Icons.details_outlined,
              color: MyConstant.dark,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
