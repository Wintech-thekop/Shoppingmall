import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
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
  LatLng? latLng;
  File? file;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    if (position != null) {
      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        print('lat = ${latLng!.latitude}');
      });
    }
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
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
            onPressed: () => processEditProfileSeller(),
            icon: Icon(Icons.edit),
            tooltip: 'Update Shop profile',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                buildTitle('General : '),
                buildName(constraints),
                buildAddress(constraints),
                buildPhone(constraints),
                buildTitle('Image Profile : '),
                buildAvatar(constraints),
                buildTitle('Location : '),
                buildMap(constraints),
                buildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> processEditProfileSeller() async {
    print('processEditProfileSeller Work');
    if (formKey.currentState!.validate()) {}
  }

  ElevatedButton buildButton() => ElevatedButton.icon(
        onPressed: () => processEditProfileSeller(),
        icon: Icon(Icons.edit),
        label: Text('Update Shop Profile'),
      );

  Row buildMap(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.5,
          child: latLng == null
              ? ShowProgress()
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: latLng!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {},
                  markers: <Marker>[
                    Marker(
                      markerId: MarkerId('id'),
                      position: latLng!,
                      infoWindow: InfoWindow(
                          title: 'Your Location',
                          snippet:
                              'lat = ${latLng!.latitude}, lng = ${latLng!.longitude}'),
                    ),
                  ].toSet(),
                ),
        ),
      ],
    );
  }

  Future<Null> processChooseImage({ImageSource? source}) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source!,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              IconButton(
                onPressed: () => processChooseImage(source: ImageSource.camera),
                icon: Icon(
                  Icons.add_a_photo,
                  color: MyConstant.dark,
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.6,
                height: constraints.maxWidth * 0.6,
                child: userModel == null
                    ? ShowProgress()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userModel!.avatar == null
                            ? ShowImage(path: MyConstant.avatar)
                            : file == null
                                ? buildShowImageNetwork()
                                : Image.file(file!),
                      ),
              ),
              IconButton(
                onPressed: () =>
                    processChooseImage(source: ImageSource.gallery),
                icon: Icon(
                  Icons.add_photo_alternate,
                  color: MyConstant.dark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork() {
    return CachedNetworkImage(
      imageUrl: '${MyConstant.domain}${userModel!.avatar}',
      placeholder: (context, url) => ShowProgress(),
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์ติดต่อร้านค้าด้วยค่ะ';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกที่อยู่ร้านค้าด้วยค่ะ';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อร้านค้าด้วยค่ะ';
              } else {
                return null;
              }
            },
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

  ShowTitle buildTitle(String title) =>
      ShowTitle(title: title, textStyle: MyConstant().h2Style());
}
