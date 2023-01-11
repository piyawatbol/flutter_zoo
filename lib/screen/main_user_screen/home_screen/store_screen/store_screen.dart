// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/add_review_screen.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/store_screen/location_store.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/store_screen/reveiw_screen.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/zoo_detail_screen.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class StoreScreen extends StatefulWidget {
  String? store_id;
  StoreScreen({required this.store_id});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List storeList = [];
  List zooList = [];
  String? user_id;
  double? star;

  Future get_zoo_store() async {
    var url = Uri.parse('$ipcon/api/zoo/get_zoo_store.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      zooList = data;
    });
  }

  Future get_store_one() async {
    var url = Uri.parse('$ipcon/api/store/get_store_one.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
    await get_avg_star(storeList[0]['store_id']);
  }

  Future get_avg_star(store_id) async {
    var url = Uri.parse('$ipcon/api/rate/get_avg_star.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      if (data[0]["AVG (star)"] != null) {
        star = double.parse(data[0]["AVG (star)"]);
      }
    });
  }

  check_rate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    var url = Uri.parse('$ipcon/api/rate/check_rate.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
      "user_id": user_id.toString()
    });
    var data = json.decode(response.body);
    print(data);
    if (data == "have") {
      Toast_Custom("คุณได้รีวิวไปแล้ว", Colors.grey);
    } else if (data == "dont have") {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return AddReveiwScreen(
          store_id: '${widget.store_id}',
        );
      }));
    }
  }

  @override
  void initState() {
    get_store_one();
    get_zoo_store();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: storeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                get_store_one();
              },
              child: Container(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAppbar(),
                      buildInfo(),
                      buildLine(),
                      buildAnimal()
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildAppbar() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: height * 0.22,
          color: pink,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )),
                          Custom_text(
                            text: "${storeList[0]['store_name']}",
                            fontSize: 34,
                            color: Colors.white,
                            fontWeight: null,
                          ),
                        ],
                      ),
                      PopupMenuButton(
                          color: Colors.white,
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem<int>(
                                textStyle: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                value: 0,
                                child: Text("Location"),
                              ),
                              PopupMenuItem<int>(
                                textStyle: GoogleFonts.itim(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                value: 1,
                                child: Text("Reveiw"),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            if (value == 0) {
                              if (storeList[0]['store_lat'] != "") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return LocationStore(
                                        store_lat:
                                            '${storeList[0]['store_lat']}',
                                        store_long:
                                            '${storeList[0]['store_long']}',
                                      );
                                    },
                                  ),
                                );
                              } else {
                                Toast_Custom(
                                    "ร้านยังไม่ได้ปักหมุด", Colors.grey);
                              }
                            } else if (value == 1) {
                              check_rate();
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -height * 0.065,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: width * 0.15,
              backgroundImage:
                  NetworkImage('$ipcon/store_img/${storeList[0]['store_img']}'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.23,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: height * 0.01),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (star != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ReveiwScreen(
                      store_id: '${widget.store_id}',
                    );
                  }));
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  star == null
                      ? Custom_text(
                          text: "ไม่มีการรีวิว",
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: null,
                        )
                      : RatingBarIndicator(
                          rating: star!,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.yellow.shade700,
                          ),
                          itemCount: 5,
                          itemSize: width * 0.05,
                        ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: width * 0.041,
                    color: Colors.grey.shade400,
                  )
                ],
              ),
            ),
            SizedBox(height: height * 0.055),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(width: width * 0.01),
                      Custom_text(
                        text: "${storeList[0]['store_province']}",
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: null,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.04,
                        height: height * 0.027,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(
                                  "assets/image/phone.png",
                                ))),
                      ),
                      storeList[0]['store_phone'] == ""
                          ? Text(
                              " -",
                              style: TextStyle(fontSize: 16),
                            )
                          : Custom_text(
                              text: "  ${storeList[0]['store_phone']}",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: null,
                            ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.005),
                        width: width * 0.045,
                        height: height * 0.025,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage("assets/image/ig.png"))),
                      ),
                      storeList[0]['store_ig'] == ""
                          ? Text(
                              " -",
                              style: TextStyle(fontSize: 16),
                            )
                          : GestureDetector(
                              onTap: () {
                                if (storeList[0]['store_ig'] != '') {
                                  final Uri url = Uri.parse(
                                      "https://www.instagram.com/${storeList[0]['store_ig']}");
                                  launchUrl(url);
                                }
                              },
                              child: Custom_text(
                                text: "  ${storeList[0]['store_ig']}",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: null,
                              ),
                            ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (storeList[0]['store_line'] != '') {
                        final Uri url = Uri.parse(
                            "https://line.me/ti/p/~${storeList[0]['store_line']}");
                        launchUrl(url);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.045,
                          height: height * 0.025,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("assets/image/line.png"))),
                        ),
                        storeList[0]['store_line'] == ""
                            ? Text(
                                " -",
                                style: TextStyle(fontSize: 16),
                              )
                            : Custom_text(
                                text: "  ${storeList[0]['store_line']}",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: null,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLine() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: width * 0.35,
            height: height * 0.045,
            decoration: BoxDecoration(
              color: pink,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Center(
              child: Custom_text(
                color: Colors.white,
                fontSize: 16,
                fontWeight: null,
                text: 'สัตว์เลี้ยง',
              ),
            ),
          ),
          Container(
            width: width * 0.6,
            height: height * 0.005,
            decoration: BoxDecoration(
              color: pink,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0.1,
                  blurRadius: 1,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildAnimal() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.62,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: zooList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ZooDetailScreen(zoo_id: '${zooList[index]['zoo_id']}');
                }));
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0.2,
                        blurRadius: 2,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            height: height * 0.23,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "$ipcon/animal_img/${zooList[index]['zoo_img']}"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.019,
                                horizontal: width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Custom_text(
                                  text: "${zooList[index]['zoo_name']}",
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: null,
                                ),
                                Custom_text(
                                  text:
                                      "นำเข้า : ${zooList[index]['zoo_import']}",
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  fontWeight: null,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            width: width * 0.2,
                            height: height * 0.025,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                color: pink2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 3),
                                Custom_text(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: null,
                                  text: '${zooList[index]['zoo_province']} ',
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              width: width * 0.08,
                              height: height * 0.035,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: zooList[index]['zoo_sex'] == "ผู้"
                                  ? Image.asset(
                                      "assets/image/male.png",
                                    )
                                  : zooList[index]['zoo_sex'] == "เมีย"
                                      ? Image.asset(
                                          "assets/image/female.png",
                                          color: Colors.red,
                                        )
                                      : Text("")),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: width * 0.21,
                          height: height * 0.035,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                  topLeft: Radius.circular(10)),
                              color: pink2),
                          child: Center(
                            child: Custom_text(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: null,
                              text: '${zooList[index]['zoo_price']} ฿',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
