// ignore_for_file: must_be_immutable, unused_local_variable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';

class AddReveiwScreen extends StatefulWidget {
  String? store_id;
  AddReveiwScreen({required this.store_id});

  @override
  State<AddReveiwScreen> createState() => _AddReveiwScreenState();
}

class _AddReveiwScreenState extends State<AddReveiwScreen> {
  TextEditingController detail = TextEditingController();
  int star = 5;
  List storeList = [];
  String? user_id;

  Future get_store_one() async {
    var url = Uri.parse('$ipcon/api/store/get_store_one.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
    });
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
  }

  Future add_rate_store() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    var url = Uri.parse('$ipcon/api/rate/add_rate_store.php');
    var response = await http.post(url, body: {
      "store_id": widget.store_id.toString(),
      "user_id": user_id.toString(),
      "rate_store_detail": detail.text,
      "star": star.toString(),
    });
    var data = json.decode(response.body);
    if (data == "Add Success") {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    get_store_one();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: pink,
          title: Custom_text(
            color: Colors.white,
            fontSize: 22,
            fontWeight: null,
            text: 'เพิ่มรีวิว',
          ),
        ),
        body: storeList.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                color: pink,
              ))
            : Container(
                width: width,
                height: height,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.04),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade400,
                        radius: width * 0.24,
                        backgroundImage: NetworkImage(
                            "$ipcon/store_img/${storeList[0]['store_img']}"),
                      ),
                    ),
                    buildStar(),
                    buildInputBox(),
                    buildSaveButton()
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildStar() {
    return RatingBar.builder(
      initialRating: 5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: pink,
      ),
      onRatingUpdate: (rating) {
        int _star = rating.toInt();
        setState(() {
          star = _star;
        });
        print(star);
      },
    );
  }

  Widget buildInputBox() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.04, horizontal: width * 0.05),
      width: width,
      height: height * 0.2,
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: detail,
        maxLines: 5,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.02),
          border: UnderlineInputBorder(borderSide: BorderSide.none),
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
          margin: EdgeInsets.symmetric(vertical: height * 0.01),
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
              add_rate_store();
            },
            child: Custom_text(
              color: Colors.white,
              fontSize: 16,
              fontWeight: null,
              text: 'บันทึก',
            ),
          ),
        ),
      ],
    );
  }
}
