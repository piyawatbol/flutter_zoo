import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/store_setting/setting_screen.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/zoo_detail_screen.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';

class HomeStoreScreen extends StatefulWidget {
  const HomeStoreScreen({super.key});

  @override
  State<HomeStoreScreen> createState() => _HomeStoreScreenState();
}

class _HomeStoreScreenState extends State<HomeStoreScreen> {
  List storeList = [];
  String? store_id;
  List zooList = [];
  String? user_id;

  Future get_zoo_store() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    var url = Uri.parse('$ipcon/api/zoo/get_zoo_store.php');
    var response = await http.post(url, body: {
      "store_id": store_id,
    });
    var data = json.decode(response.body);
    setState(() {
      zooList = data;
    });
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
  }

  @override
  void initState() {
    get_store();
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
                get_store();
              },
              child: Container(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildImage(),
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

  Widget buildImage() {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: Custom_text(
                        text: "${storeList[0]['store_name']}",
                        fontSize: 34,
                        color: Colors.white,
                        fontWeight: null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return EditStoreScreen();
                          })).then((value) => get_zoo_store());
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
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
        )
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
            horizontal: width * 0.04, vertical: height * 0.01),
        child: Column(
          children: [
            SizedBox(height: height * 0.075),
            Row(
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
                    : Custom_text(
                        text: "  ${storeList[0]['store_ig']}",
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
