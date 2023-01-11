// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/store_screen/store_screen.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class ZooDetailScreen extends StatefulWidget {
  String? zoo_id;
  ZooDetailScreen({required this.zoo_id});

  @override
  State<ZooDetailScreen> createState() => _ZooDetailScreenState();
}

class _ZooDetailScreenState extends State<ZooDetailScreen> {
  List zooList = [];
  List storeList = [];
  bool star = false;
  String? user_id;

  get_zoo_one() async {
    final response = await http.get(
        Uri.parse("$ipcon/api/zoo/get_zoo_one.php?zoo_id=${widget.zoo_id}"));
    var data = json.decode(response.body);

    setState(() {
      zooList = data;
    });
    get_store_one(zooList[0]['store_id'].toString());
  }

  Future get_store_one(String? store_id) async {
    var url = Uri.parse('$ipcon/api/store/get_store_one.php');
    var response = await http.post(url, body: {
      "store_id": store_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
  }

  check_star() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    var url = Uri.parse('$ipcon/api/star/check_star.php');
    var response = await http.post(url, body: {
      "zoo_id": widget.zoo_id.toString(),
      "user_id": user_id.toString(),
    });
    var data = json.decode(response.body);
    if (data == "have") {
      setState(() {
        star = true;
      });
    } else {
      setState(() {
        star = false;
      });
    }
  }

  add_star() async {
    var url = Uri.parse('$ipcon/api/star/add_star.php');
    var response = await http.post(url, body: {
      "zoo_id": widget.zoo_id.toString(),
      "user_id": user_id.toString(),
    });
    var data = json.decode(response.body);
    if (data == "Add Success") {
      Toast_Custom("เพิ่มสัตว์ที่ถูกใจ", Colors.grey.shade400);
    }
  }

  delete_star() async {
    var url = Uri.parse('$ipcon/api/star/delete_star.php');
    var response = await http.post(url, body: {
      "zoo_id": widget.zoo_id.toString(),
      "user_id": user_id.toString(),
    });
    var data = json.decode(response.body);
    if (data == "Delete Success") {
      Toast_Custom("ลบสัตว์ที่ถูกใจ", Colors.grey.shade400);
    }
  }

  @override
  void initState() {
    get_zoo_one();
    check_star();
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
          fontSize: 24,
          fontWeight: null,
          text: 'รายละเอียด',
        ),
      ),
      body: zooList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildImg(),
                        Container(
                          height: height * 0.68,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInfo(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      buildStar(),
                                      buildPrice(),
                                    ],
                                  ),
                                ],
                              ),
                              buildRow(),
                              buildDetail(),
                              buildDate()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildBottom()
                ],
              ),
            ),
    );
  }

  Widget buildImg() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.42,
      decoration: BoxDecoration(
        color: Color(0xffdedede),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0.1,
            blurRadius: 0.5,
            offset: Offset(0, 0),
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.contain,
          image: NetworkImage('$ipcon/animal_img/${zooList[0]['zoo_img']}'),
        ),
      ),
    );
  }

  Widget buildInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.015, horizontal: width * 0.05),
      width: width * 0.7,
      height: height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Custom_text(
            text: "${zooList[0]['zoo_name']}",
            fontSize: 26,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: height * 0.015),
          Custom_text(
            text: "ชนิด : ${zooList[0]['zoo_type']}",
            fontSize: 18,
            color: Colors.black,
            fontWeight: null,
          ),
          SizedBox(width: width * 0.08),
          Custom_text(
            text: "ฟาร์ม : ${zooList[0]['zoo_farm']}",
            fontSize: 18,
            color: Colors.black,
            fontWeight: null,
          ),
          Custom_text(
            text: "เลขใบที่นำเข้า : ${zooList[0]['zoo_license']}",
            fontSize: 18,
            color: Colors.black,
            fontWeight: null,
          ),
          Custom_text(
            text: "นำเข้า : ${zooList[0]['zoo_import']}",
            fontSize: 18,
            color: Colors.black,
            fontWeight: null,
          ),
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: pink,
              ),
              Custom_text(
                text: "${zooList[0]['zoo_province']}",
                fontSize: 18,
                color: Colors.black,
                fontWeight: null,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildStar() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      width: width * 0.2,
      height: height * 0.05,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0.1,
            blurRadius: 0.5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (star == true) {
            delete_star();
          } else {
            add_star();
          }
          setState(() {
            star = !star;
          });
        },
        child: star == true
            ? Icon(
                Icons.star,
                color: Colors.yellow,
                size: 30,
              )
            : Icon(
                Icons.star_outline,
                color: Colors.yellow,
                size: 30,
              ),
      ),
    );
  }

  Widget buildPrice() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.3,
      height: height * 0.05,
      decoration: BoxDecoration(
        color: pink,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0.1,
            blurRadius: 0.5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Custom_text(
          color: Colors.white,
          fontSize: 16,
          fontWeight: null,
          text: '${zooList[0]['zoo_price']} ฿ ',
        ),
      ),
    );
  }

  Widget buildRow() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: width * 0.3,
            height: height * 0.065,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0.1,
                  blurRadius: 0.5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Custom_text(
                  color: pink,
                  fontSize: 18,
                  fontWeight: null,
                  text: 'เพศ',
                ),
                Custom_text(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: null,
                  text: '${zooList[0]['zoo_sex']}',
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.02),
            width: width * 0.3,
            height: height * 0.065,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0.1,
                  blurRadius: 0.5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Custom_text(
                  color: pink,
                  fontSize: 18,
                  fontWeight: null,
                  text: 'วันเกิด',
                ),
                Custom_text(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: null,
                  text: '${zooList[0]['zoo_brithday']}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetail() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Custom_text(
            text: "รายละเอียด",
            fontSize: 18,
            color: Colors.black,
            fontWeight: null,
          ),
          Custom_text2(
            text: "${zooList[0]['zoo_detail']}",
            fontSize: 16,
            color: Colors.grey,
            fontWeight: null,
          ),
        ],
      ),
    );
  }

  Widget buildDate() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.06),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Custom_text(
            text: "ลงวันที่",
            fontSize: 18,
            color: Colors.black,
            fontWeight: null,
          ),
          Custom_text2(
            text: "${zooList[0]['zoo_date']}",
            fontSize: 16,
            color: Colors.grey,
            fontWeight: null,
          ),
        ],
      ),
    );
  }

  Widget buildBottom() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: 0,
      child: Container(
        width: width,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: pink,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0.3,
              blurRadius: 0.5,
              offset: Offset(-1, 0),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  storeList.isEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: width * 0.07,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: width * 0.07,
                          backgroundImage: NetworkImage(
                              "$ipcon/store_img/${storeList[0]['store_img']}"),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Custom_text(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: null,
                          text: 'ผู้ขาย',
                        ),
                        storeList.isEmpty
                            ? Text("...")
                            : Custom_text(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: null,
                                text: '${storeList[0]['store_name']}',
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return StoreScreen(
                      store_id: '${storeList[0]['store_id'].toString()}',
                    );
                  }));
                },
                child: Custom_text(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: null,
                  text: 'ติดต่อ',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
