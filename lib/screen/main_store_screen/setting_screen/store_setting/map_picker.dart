// ignore_for_file: unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/loading_screen.dart';

class MappickerScreen extends StatefulWidget {
  const MappickerScreen({Key? key}) : super(key: key);

  @override
  _MappickerScreenState createState() => _MappickerScreenState();
}

class _MappickerScreenState extends State<MappickerScreen> {
  bool statusLoading = false;
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  Position? userLocation;
  double? lati;
  double? longti;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 18,
  );

  Future<Position?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return userLocation;
  }

  pin_map(lat, long) async {
    String? store_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    var url = Uri.parse('$ipcon/api/store/update_location.php');
    var response = await http.post(url, body: {
      "store_id": store_id.toString(),
      "store_lat": lat.toString(),
      "store_long": long.toString()
    });
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
              // pass icon widget
              iconWidget: Image.asset(
                "assets/image/pin.png",
                height: 60,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: FutureBuilder(
                future: _getLocation(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return GoogleMap(
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      // hide location button
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      //  camera position
                      initialCameraPosition: CameraPosition(
                        zoom: 18,
                        target: LatLng(
                            userLocation!.latitude, userLocation!.longitude),
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMoveStarted: () {
                        // notify map is moving
                        mapPickerController.mapMoving!();
                      },
                      onCameraMove: (cameraPosition) {
                        this.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () async {
                        // notify map stopped moving
                        mapPickerController.mapFinishedMoving!();
                        //get address name from camera position
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude,
                        );
                        // update the ui with the address
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: TextFormField(
              maxLines: 3,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, border: InputBorder.none),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 50,
              child: TextButton(
                child: const Text(
                  "Pin",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFFFFFFF),
                    fontSize: 19,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    statusLoading = true;
                  });
                  print(
                      "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                  pin_map(cameraPosition.target.latitude,
                      cameraPosition.target.longitude);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(pink),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 35,
                      color: pink,
                    ),
                  ),
                  Text(
                    "Pin Store",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: pink),
                  ),
                ],
              ),
            ),
          ),
          LoadingScreen(statusLoading: statusLoading)
        ],
      ),
    );
  }
}
