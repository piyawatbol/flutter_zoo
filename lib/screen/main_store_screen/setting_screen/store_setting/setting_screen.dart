import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/screen/login_system/login_screen.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/animal_setting/animal_settting.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/store_setting/location_setting_screen.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/store_setting/store_setting.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({super.key});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        elevation: 1,
        title: Custom_text(
          text: "ตั้งค่า",
          fontSize: 20,
          color: Colors.white,
          fontWeight: null,
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            SizedBox(height: height * 0.005),
            buildBox("ตั้งค่าร้านค้า"),
            buildBox("ตั้งค่าสถานที่ตั้งร้าน"),
            buildBox("ตั้งค่าสัตว์เลี้ยง"),
            buildLogoutButton()
          ],
        ),
      ),
    );
  }

  Widget buildBox(String? text) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (text == "ตั้งค่าร้านค้า") {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return StoreSettingScreen();
          }));
        } else if (text == "ตั้งค่าสัตว์เลี้ยง") {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AnimalSettingScreen();
          }));
        } else if (text == "ตั้งค่าสถานที่ตั้งร้าน") {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return LocationSettingScreen();
          }));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.005),
        width: width,
        height: height * 0.06,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Custom_text(
              color: pink,
              fontSize: 18,
              fontWeight: null,
              text: '$text',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogoutButton() {
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
}
