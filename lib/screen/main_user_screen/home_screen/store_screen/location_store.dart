// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zoo_app/widget/color.dart';

class LocationStore extends StatefulWidget {
  String? store_lat;
  String? store_long;
  LocationStore({required this.store_lat, required this.store_long});
  @override
  State<LocationStore> createState() => _LocationStoreState();
}

class _LocationStoreState extends State<LocationStore> {
  GoogleMapController? mapController;
  final Set<Marker> markers = new Set();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(double.parse(widget.store_lat.toString()),
            double.parse(widget.store_long.toString())),
        infoWindow: InfoWindow(
          title: 'My Custom Title ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              zoomControlsEnabled: false,
              markers: markers,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                zoom: 15,
                target: LatLng(double.parse(widget.store_lat.toString()),
                    double.parse(widget.store_long.toString())),
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
                      size: 30,
                      color: pink,
                    ),
                  ),
                  Text(
                    "สถานที่ตั้งร้าน",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: pink),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
