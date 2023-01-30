import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/login_system/register_screen.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/store_setting/add_store_screen.dart';
import 'package:zoo_app/screen/main_store_screen/home_store_screen.dart';
import 'package:zoo_app/screen/main_user_screen/tab_screen.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/inputsytle.dart';
import 'package:zoo_app/widget/loading_screen.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool statusLoading = false;
  List userList = [];
  List storeList = [];
  TextEditingController user_name = TextEditingController();
  TextEditingController pass_word = TextEditingController();

  login() async {
    var url = Uri.parse('$ipcon/api/login_system/login.php');
    var response = await http.post(url, body: {
      "user_name": user_name.text,
      "pass_word": pass_word.text,
    });
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
    }
    if (data == "not find accout") {
      Toast_Custom("ชื่อผู้ใช้ หรือ รหัสผ่านไม่ถูกต้อง", Colors.red);
    } else {
      setState(() {
        userList = data;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user_id', userList[0]['user_id']);
      preferences.setString('user_type', userList[0]['user_type']);
      if (userList[0]['user_type'] == 'user') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return TabScreen();
        }));
      } else {
        check_store(userList[0]['user_id'].toString());
      }
    }
  }

  check_store(user_id) async {
    var url = Uri.parse('$ipcon/api/store/check_store.php');
    var response = await http.post(url, body: {
      "user_id": user_id.toString(),
    });
    var data = json.decode(response.body);
    if (data == "not find store") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return AddStoreScreen();
      }));
    } else {
      setState(() {
        storeList = data;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('store_id', storeList[0]['store_id']);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomeStoreScreen();
      }));
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
        body: Container(
          width: width,
          height: height,
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.034),
                        Custom_text(
                          color: pink,
                          fontSize: 45,
                          fontWeight: null,
                          text: 'Log in',
                        ),
                        Image.asset(
                          "assets/image/login_logo.png",
                          width: width * 0.5,
                          height: height * 0.4,
                        ),
                        buildInputBox(user_name, Icons.email, "Username"),
                        buildInputBox(pass_word, Icons.key, "Password"),
                        SizedBox(height: height * 0.03),
                        buildSingInButton(),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Custom_text(
                                color: pink,
                                fontSize: 16,
                                fontWeight: null,
                                text: 'Didnt have an accout ? ',
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return RegisterScreen();
                                  }));
                                },
                                child: Custom_text(
                                  color: pink,
                                  fontSize: 16,
                                  fontWeight: null,
                                  text: 'Sing Up',
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                LoadingScreen(statusLoading: statusLoading)
              ],
            ),
          ),
        ),
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

  Widget buildSingInButton() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.002),
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
            setState(() {
              statusLoading = true;
            });
            login();
          }
        },
        child: Custom_text(
          color: Colors.white,
          fontSize: 16,
          fontWeight: null,
          text: 'LOGIN',
        ),
      ),
    );
  }
}
