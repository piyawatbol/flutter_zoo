// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code, unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/search_screen.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/zoo_detail_screen.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/zoo_type_screen.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/color.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List zooList = [];
  List userList = [];
  int _index = 0;
  String? image;
  String? user_id;
  get_zoo() async {
    final response = await http.get(Uri.parse("$ipcon/api/zoo/get_zoo.php"));
    var data = json.decode(response.body);
    setState(() {
      zooList = data;
    });
  }

  List<String> images_slide = [
    "assets/image/zoo.jpg",
    "assets/image/zoo1.jpg",
    "assets/image/zoo2.jpg",
  ];
  List img_group = [
    "dog.png",
    "cat.png",
    "brid.png",
    "rabbit.png",
    "turtle.png",
    "snake.png",
    "porcupine.png",
    "fish.png"
  ];
  List text_group = [
    'สุนัข',
    'แมว',
    'นก',
    'กระต่าย',
    'เต่า',
    'งู',
    'เม่น',
    'ปลา'
  ];

  Future get_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    var url = Uri.parse('$ipcon/api/user/get_user.php');
    var response = await http.post(url, body: {
      "user_id": user_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      userList = data;
      image = userList[0]['user_img'];
    });
  }

  @override
  void initState() {
    get_zoo();
    get_user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: buildAppbar(),
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCarousel(),
              buildgrop(),
              buildLine(),
              buildAnimalRecommend(),
            ],
          ),
        ),
      ),
    );
  }

  buildAppbar() {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 1,
      backgroundColor: pink,
      centerTitle: true,
      title: Custom_text(
        color: Colors.white,
        fontSize: 20,
        text: 'OH MY PET',
        fontWeight: FontWeight.w400,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return SearchScreen();
            }));
          },
        ),
        image == "" || image == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: width * 0.04,
                  backgroundColor: pink2,
                  child: Image.asset(
                    "assets/image/profile.png",
                    color: Colors.white,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: width * 0.044,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: width * 0.04,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage("$ipcon/user_img/${image}"),
                  ),
                ),
              )
      ],
    );
  }

  Widget buildCarousel() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: width,
              height: height * 0.25,
              child: CarouselSlider.builder(
                itemCount: images_slide.length,
                itemBuilder: ((context, index, realIndex) {
                  return Container(
                    width: width,
                    height: height * 0.2,
                    child: Image.asset(
                      '${images_slide[index]}',
                      fit: BoxFit.cover,
                    ),
                  );
                }),
                options: CarouselOptions(
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _index = index;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.01),
              child: AnimatedSmoothIndicator(
                activeIndex: _index,
                count: images_slide.length,
                effect: WormEffect(
                  activeDotColor: Colors.pink.shade200,
                  dotHeight: 5,
                  dotWidth: 10,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildgrop() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.25,
      child: GridView.builder(
          padding: EdgeInsets.all(15),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              crossAxisSpacing: 10),
          itemCount: 8,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ZooTypeScreen(
                    zoo_type: '${text_group[index]}',
                  );
                }));
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0.1,
                        blurRadius: 1,
                        offset: Offset(1.3, 2.5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.13,
                        height: height * 0.055,
                        child: Image.asset(
                          "assets/image/${img_group[index]}",
                          color: pink2,
                        ),
                      ),
                      Custom_text(
                          text: "${text_group[index]}",
                          fontSize: 13,
                          color: pink2,
                          fontWeight: null)
                    ],
                  )),
            );
          }),
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
                text: 'สัตว์เลี้ยงแนะนำ',
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

  Widget buildAnimalRecommend() {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ZooDetailScreen(
                        zoo_id: '${zooList[index]['zoo_id']}',
                      );
                    },
                  ),
                );
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
