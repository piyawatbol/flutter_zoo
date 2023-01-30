import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({super.key});

  @override
  State<NotiScreen> createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  List notiList = [];
  get_noti() async {
    final response = await http.get(Uri.parse("$ipcon/api/noti/get_noti.php"));
    var data = json.decode(response.body);
    setState(() {
      notiList = data;
    });
  }

  @override
  void initState() {
    get_noti();
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
          color: Colors.white,
          fontSize: 24,
          fontWeight: null,
          text: 'แจ้งเตือน',
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [buildListNoti()],
        ),
      ),
    );
  }

  Widget buildListNoti() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
        child: ListView.builder(
      itemCount: notiList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 1,
                offset: Offset(1, 1),
              ),
            ],
          ),
          width: width,
          height: height * 0.12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.027),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: width * 0.11,
                      backgroundImage: NetworkImage(
                          "$ipcon/animal_img/${notiList[index]['zoo_img']}"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: width * 0.03,
                        backgroundImage: NetworkImage(
                            "$ipcon/store_img/${notiList[index]['store_img']}"),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.02),
                width: width * 0.71,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Custom_text(
                      text:
                          "${notiList[index]['store_name']} ${notiList[index]['noti_detail']}",
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: null,
                    ),
                    Custom_text(
                      text: "${notiList[index]['zoo_name']}",
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: null,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
