import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/login_system/login_screen.dart';
import 'package:zoo_app/screen/main_user_screen/profile_screen/edit_profile_screen.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List userList = [];
  String? user_id;

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
    if (this.mounted) {
      setState(() {
        userList = data;
      });
    }
  }

  delete_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http
        .get(Uri.parse("$ipcon/api/user/delete_user.php?user_id=$user_id"));
    var data = json.decode(response.body);
    print(data);
    if (data == "Delete Success") {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen();
      }), (route) => false);
    }
  }

  @override
  void initState() {
    get_user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: pink,
        title: Custom_text(
          color: Colors.white,
          fontSize: 24,
          fontWeight: null,
          text: 'บัญชีผู้ใช้',
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showModalBottomSheet();
              },
              icon: Icon(Icons.delete_forever))
        ],
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator(color: pink))
          : Container(
              width: width,
              height: height,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [buildBgProfile(), buildProfile()],
              ),
            ),
    );
  }

  Widget buildBgProfile() {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.2,
      decoration: BoxDecoration(
        color: pink2,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/image/bg_profile.jpg'),
        ),
      ),
    );
  }

  Widget buildProfile() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              vertical: height * 0.095, horizontal: width * 0.04),
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0.2,
                blurRadius: 0.2,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.09),
              Custom_text(
                color: Colors.black,
                fontSize: 22,
                fontWeight: null,
                text: 'สวัสดีคุณ',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.016),
                child: Column(
                  children: [
                    Custom_text(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: null,
                      text:
                          '${userList[0]['first_name']} ${userList[0]['last_name']}',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1, vertical: height * 0.013),
                      child: Divider(
                        height: 1,
                      ),
                    )
                  ],
                ),
              ),
              buildInfoProfile(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.04),
          child: userList[0]['user_img'] == ""
              ? CircleAvatar(
                  radius: width * 0.13,
                  backgroundColor: pink,
                  child: Image.asset(
                    'assets/image/profile.png',
                    color: Colors.white,
                    width: width * 0.2,
                  ),
                )
              : CircleAvatar(
                  radius: width * 0.13,
                  backgroundColor: pink,
                  backgroundImage: NetworkImage(
                      "$ipcon/user_img/${userList[0]['user_img']}"),
                ),
        ),
      ],
    );
  }

  Widget buildInfoProfile() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.74,
      height: height * 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Custom_text(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w200,
            text: 'เบอร์โทรศัพท์',
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Container(
              padding: EdgeInsets.all(7),
              width: width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5)),
              child: Custom_text(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w200,
                text: '${userList[0]['phone']}',
              ),
            ),
          ),
          Custom_text(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w200,
            text: 'อีเมล',
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Container(
              padding: EdgeInsets.all(7),
              width: width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5)),
              child: Custom_text(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w200,
                text: '${userList[0]['email']}',
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          buildEditButton(),
          SizedBox(height: height * 0.02),
          buildLogoutButton()
        ],
      ),
    );
  }

  Widget buildEditButton() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.5,
          height: height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.grey.shade400,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return EditProfileScreen(
                  email: '${userList[0]['email']}',
                  phome: '${userList[0]['phone']}',
                  first_name: '${userList[0]['first_name']}',
                  last_name: '${userList[0]['last_name']}',
                  user_img: '${userList[0]['user_img']}',
                );
              })).then((value) => get_user());
            },
            child: Custom_text(
              color: Colors.white,
              fontSize: 16,
              fontWeight: null,
              text: 'แก้ไขโปรไฟล์',
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLogoutButton() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return LoginScreen();
              }), (route) => false);
            },
            child: Custom_text(
              color: Colors.white,
              fontSize: 16,
              fontWeight: null,
              text: 'ออกจากระบบ',
            ),
          ),
        ),
      ],
    );
  }

  void _showModalBottomSheet() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          width: width,
          height: height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Custom_text(
                color: Colors.black,
                fontSize: 22,
                text: 'ต้องการลบบัญชีผู้ใช้หรือไม่?',
                fontWeight: null,
              ),
              Column(
                children: [
                  Container(
                    width: width * 0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: pink,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      onPressed: () async {
                        delete_user();
                      },
                      child: Custom_text(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: null,
                        text: 'ตกลง',
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.grey.shade400,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Custom_text(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: null,
                        text: 'ยกเลิก',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
