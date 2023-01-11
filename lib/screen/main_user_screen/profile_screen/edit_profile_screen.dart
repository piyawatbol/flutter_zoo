// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/inputsytle.dart';
import 'package:zoo_app/widget/loading_screen.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class EditProfileScreen extends StatefulWidget {
  String? first_name;
  String? last_name;
  String? email;
  String? phome;
  String? user_img;
  EditProfileScreen(
      {required this.email,
      required this.phome,
      required this.first_name,
      required this.last_name,
      required this.user_img});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController? email;
  TextEditingController? phone;
  TextEditingController? first_name;
  TextEditingController? last_name;
  File? image;
  String? user_id;
  bool statusLoading = false;

  edit_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final uri = Uri.parse("$ipcon/api/user/edit_user.php");
    var request = http.MultipartRequest('POST', uri);
    if (image != null) {
      var img = await http.MultipartFile.fromPath("img", image!.path);
      request.files.add(img);
    }
    request.fields['user_id'] = user_id.toString();
    request.fields['first_name'] = first_name!.text;
    request.fields['last_name'] = last_name!.text;
    request.fields['email'] = email!.text;
    request.fields['phone'] = phone!.text;

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print(responseBody);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      Navigator.pop(context);
      Toast_Custom("บันทึกข้อมูลเสร็จสิ้น", Colors.green);
    } else {
      setState(() {
        statusLoading = false;
      });
      Toast_Custom("ไม่สามารถบันทึกข้อมูลได้", Colors.red);
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    email = TextEditingController(text: '${widget.email}');
    phone = TextEditingController(text: '${widget.phome}');
    first_name = TextEditingController(text: '${widget.first_name}');
    last_name = TextEditingController(text: '${widget.last_name}');
    super.initState();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: pink,
          title: Custom_text(
            color: Colors.white,
            fontSize: 24,
            fontWeight: null,
            text: 'อีเมล',
          ),
        ),
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    buildImg(),
                    buildBox("ชื่อ", first_name),
                    buildBox("นามสกุล", last_name),
                    buildBox("อีเมล", email),
                    buildBox("โทรศัพท์", phone),
                    SizedBox(height: height * 0.03),
                    buildSaveButton(),
                  ],
                ),
                LoadingScreen(statusLoading: statusLoading)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImg() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.04),
      child: Stack(
        children: [
          widget.user_img == ""
              ? CircleAvatar(
                  radius: width * 0.19,
                  backgroundColor: pink,
                  child: Image.asset(
                    'assets/image/profile.png',
                    color: Colors.white,
                    width: width * 0.2,
                  ),
                )
              : image == null
                  ? CircleAvatar(
                      radius: width * 0.19,
                      backgroundColor: pink,
                      backgroundImage:
                          NetworkImage("$ipcon/user_img/${widget.user_img}"),
                    )
                  : CircleAvatar(
                      radius: width * 0.19,
                      backgroundColor: pink,
                      backgroundImage: FileImage(image!),
                    ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0.1,
                    blurRadius: 0.4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Icon(
                  Icons.camera_alt,
                  color: pink,
                  size: width * 0.07,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBox(String? text1, TextEditingController? controller) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Custom_text(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w200,
            text: '$text1',
          ),
          SizedBox(height: height * 0.02),
          TextField(
            style: GoogleFonts.itim(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            controller: controller,
            decoration: inputStyle2(context),
          ),
        ],
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
              setState(() {
                statusLoading = true;
              });
              edit_user();
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
