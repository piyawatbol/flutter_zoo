// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';

class ReveiwScreen extends StatefulWidget {
  String? store_id;
  ReveiwScreen({required this.store_id});

  @override
  State<ReveiwScreen> createState() => _ReveiwScreenState();
}

class _ReveiwScreenState extends State<ReveiwScreen> {
  List rateList = [];
  int select = 0;

  Future get_star_all() async {
    var url = Uri.parse('$ipcon/api/rate/get_star_all.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      rateList = data;
    });
  }

  Future get_star_only(String? star) async {
    var url = Uri.parse('$ipcon/api/rate/get_star_only.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
      "star": star.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      rateList = data;
    });
  }

  @override
  void initState() {
    get_star_all();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: pink,
        title: Custom_text(
          text: "Review",
          fontSize: 24,
          color: Colors.white,
          fontWeight: null,
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [buildStar(), buildRateList()],
          ),
        ),
      ),
    );
  }

  Widget buildStar() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.005, horizontal: width * 0.005),
      height: height * 0.055,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                select = index;
              });
              if (select == 0) {
                get_star_all();
              } else {
                get_star_only(select.toString());
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.005),
              width: width * 0.155,
              height: height * 0.05,
              decoration: BoxDecoration(
                color: index == select ? Colors.white70 : pink,
                border: index == select
                    ? Border.all(color: Colors.black, width: 1)
                    : null,
              ),
              child: Center(
                child: Custom_text(
                  text: index == 0 ? "All" : "$index",
                  fontSize: 20,
                  color: index == select ? Colors.black : Colors.white,
                  fontWeight: null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRateList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return rateList.isEmpty
        ? SizedBox(
            height: height * 0.8,
            child: Center(
              child: CircularProgressIndicator(
                color: pink,
              ),
            ),
          )
        : rateList[0] == "not have rate"
            ? SizedBox()
            : SizedBox(
                child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                itemCount: rateList.length,
                itemBuilder: (BuildContext context, int index) {
                  double star =
                      double.parse(rateList[index]['star'].toString());
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    width: width,
                    height: height * 0.13,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            rateList[index]['user_img'] == ""
                                ? CircleAvatar(
                                    radius: 10,
                                    backgroundColor: pink,
                                    backgroundImage:
                                        AssetImage('assets/image/profile.png'),
                                  )
                                : CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(
                                        "$ipcon/user_img/${rateList[index]['user_img']}"),
                                  ),
                            SizedBox(width: width * 0.01),
                            Custom_text(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: null,
                              text:
                                  '${rateList[index]['first_name']} ${rateList[index]['last_name']}',
                            ),
                          ],
                        ),
                        RatingBarIndicator(
                          rating: star,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: width * 0.04,
                        ),
                        Custom_text(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: null,
                          text: '${rateList[index]['rate_store_detail']}',
                        ),
                        Custom_text(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: null,
                          text:
                              '${rateList[index]['date']} ${rateList[0]['time']}',
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
