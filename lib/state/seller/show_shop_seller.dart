import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
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
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowTitle(
                    title: 'Name Shop :', textStyle: MyConstant().h2Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowTitle(
                          title: userModel!.name,
                          textStyle: MyConstant().h1Style()),
                    ),
                  ],
                ),
                ShowTitle(title: 'Address:', textStyle: MyConstant().h2Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: constraints.maxWidth * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShowTitle(
                            title: userModel!.address,
                            textStyle: MyConstant().h2Style()),
                      ),
                    ),
                  ],
                ),
                ShowTitle(
                    title: 'Phone: ${userModel!.phone}',
                    textStyle: MyConstant().h2Style()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ShowTitle(
                      title: 'Avatar: ', textStyle: MyConstant().h2Style()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      width: constraints.maxWidth * 0.70,
                      child: CachedNetworkImage(
                        imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                        placeholder: (context, url) => ShowProgress(),
                      ),
                    ),
                  ],
                ),
                ShowTitle(
                    title: 'Location:', textStyle: MyConstant().h2Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: constraints.maxWidth * 0.7,
                      height: constraints.maxWidth * 0.7,
                      // color: Colors.grey,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(userModel!.lat),
                              double.parse(userModel!.lng),
                            ),
                            zoom: 16),
                        markers: <Marker>[
                          Marker(
                            markerId: MarkerId('id'),
                            position: LatLng(
                              double.parse(userModel!.lat),
                              double.parse(userModel!.lng),
                            ),
                            infoWindow: InfoWindow(
                                title: '${userModel!.name} Shop Here ',
                                snippet:
                                    'lat = ${userModel!.lat}, lng = ${userModel!.lng}'),
                          ),
                        ].toSet(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
