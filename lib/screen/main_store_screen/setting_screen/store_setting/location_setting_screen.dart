import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/store_setting/map_picker.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';

class LocationSettingScreen extends StatefulWidget {
  const LocationSettingScreen({super.key});

  @override
  State<LocationSettingScreen> createState() => _LocationSettingScreenState();
}

class _LocationSettingScreenState extends State<LocationSettingScreen> {
  List storeList = [];
  GoogleMapController? mapController;
  final Set<Marker> markers = new Set();
  String? user_id;
  Position? userLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future get_store() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    var url = Uri.parse('$ipcon/api/store/get_store.php');
    var response = await http.post(url, body: {
      "user_id": user_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
    if (storeList[0]['store_lat'] != '') {
      setState(() {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 15,
              target: LatLng(double.parse(storeList[0]['store_lat']),
                  double.parse(storeList[0]['store_long'])),
            ),
          ),
        );
      });
      markers.add(
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(double.parse(storeList[0]['store_lat']),
              double.parse(storeList[0]['store_long'])),
          infoWindow: InfoWindow(
            title: 'My Custom Title ',
            snippet: 'My Custom Subtitle',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
  }

  @override
  void initState() {
    get_store();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: pink,
        title: Custom_text(
          color: Colors.white,
          fontSize: 22,
          fontWeight: null,
          text: 'สถานที่ตั้งร้าน',
        ),
      ),
      body: storeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: Column(
                children: [buildMap(), buildSaveButton()],
              ),
            ),
    );
  }

  Widget buildMap() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return storeList[0]['store_lat'] == ''
        ? Container(
            margin: EdgeInsets.all(20),
            width: width,
            height: height * 0.4,
            color: Colors.grey.shade200,
            child: Center(
              child: Custom_text(
                color: pink,
                fontSize: 22,
                fontWeight: null,
                text: 'ยังไม่ได้ปักหมุด',
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.all(20),
            width: width,
            height: height * 0.5,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              zoomControlsEnabled: false,
              markers: markers,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                zoom: 15,
                target: LatLng(double.parse(storeList[0]['store_lat']),
                    double.parse(storeList[0]['store_long'])),
              ),
            ),
          );
  }

  Widget buildSaveButton() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.03),
          width: width * 0.5,
          height: height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: pink,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MappickerScreen();
              })).then((value) => get_store());
            },
            child: Custom_text(
              color: Colors.white,
              fontSize: 16,
              fontWeight: null,
              text: 'ปักหมุด',
            ),
          ),
        ),
      ],
    );
  }
}
