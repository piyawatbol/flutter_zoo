import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/inputsytle.dart';
import 'package:http/http.dart' as http;
import 'package:zoo_app/widget/loading_screen.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectItem;
  List item = ["user", "store"];
  bool statusLoading = false;
  TextEditingController user_name = TextEditingController();
  TextEditingController pass_word = TextEditingController();
  TextEditingController frist_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController confirm_pass = TextEditingController();

  register() async {
    var url = Uri.parse('$ipcon/api/login_system/register.php');
    var response = await http.post(url, body: {
      "user_name": user_name.text,
      "pass_word": pass_word.text,
      "first_name": frist_name.text,
      "lastname": last_name.text,
      "email": email.text,
      "phone": phone.text,
      "user_type": selectItem,
    });
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
    }
    if (data == "duplicate_username") {
      Toast_Custom("ชื่อผู้ใช้นี้ถูกใช้ไปแล้ว", Colors.red);
    } else if (data == "duplicate_email") {
      Toast_Custom("อีเมลนี้ถูกใช้ไปแล้ว", Colors.red);
    } else if (data == "duplicate_phone") {
      Toast_Custom("เบอร์โทรศัพท์นี้ใช้ไปแล้ว", Colors.red);
    } else if (data == "register succes") {
      Toast_Custom("สมัครเสร็จสิ้น", Colors.green);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: pink,
            ),
          ),
          body: Container(
            width: width,
            height: height,
            color: Colors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Custom_text(
                          color: pink,
                          fontSize: 45,
                          fontWeight: null,
                          text: 'Register',
                        ),
                        Image.asset(
                          "assets/image/register_logo.png",
                          width: width * 0.8,
                          height: height * 0.25,
                        ),
                        buildInputBox(user_name, Icons.person, "Username"),
                        buildInputBox(frist_name, Icons.person, "Firstname"),
                        buildInputBox(last_name, Icons.person, "Lastname"),
                        buildInputBox(email, Icons.email, "Email"),
                        buildInputBox(phone, Icons.phone, "Phone"),
                        buildInputBox(pass_word, Icons.key, "Password"),
                        buildInputBox(
                            confirm_pass, Icons.key, "Confirm Password"),
                        buildDropDown1(),
                        buildRegisterButton()
                      ],
                    ),
                  ),
                ),
                LoadingScreen(statusLoading: statusLoading)
              ],
            ),
          )),
    );
  }

  Widget buildDropDown1() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      width: width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0.4,
            blurRadius: 0.5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            iconSize: width * 0.11,
            borderRadius: BorderRadius.circular(20),
            value: selectItem,
            items: item.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Row(
                  children: [
                    SizedBox(width: width * 0.08),
                    Custom_text(
                      text: item.toString(),
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: null,
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) async {
              setState(() {
                selectItem = v.toString();
              });
            }),
      ),
    );
  }

  Widget buildInputBox(
      TextEditingController? controller, IconData? icon, String? hintText) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.07, vertical: height * 0.01),
      child: TextFormField(
          controller: controller,
          obscureText: icon == Icons.key ? true : false,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกข้อมูล';
            }
            return null;
          },
          cursorColor: pink,
          style: GoogleFonts.itim(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          decoration: inputStyle(context, icon, hintText)),
    );
  }

  Widget buildRegisterButton() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      width: width * 0.85,
      height: height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: pink,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          final isValid = formKey.currentState!.validate();
          if (isValid) {
            if (pass_word.text != confirm_pass.text) {
              Toast_Custom("รหัสผ่านไม่ตรงกัน", Colors.red);
            } else if (selectItem == null || selectItem == '') {
              Toast_Custom("กรุณาเลือกประเภทผู้ใช้", Colors.red);
            } else {
              setState(() {
                statusLoading = true;
              });
              register();
            }
          }
        },
        child: Custom_text(
          color: Colors.white,
          fontSize: 18,
          fontWeight: null,
          text: 'Register',
        ),
      ),
    );
  }
}
