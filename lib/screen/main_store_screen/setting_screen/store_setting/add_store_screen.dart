// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/main_store_screen/home_store_screen.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/inputsytle.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class AddStoreScreen extends StatefulWidget {
  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController store_name = TextEditingController();
  TextEditingController store_phone = TextEditingController();
  TextEditingController store_sub_district = TextEditingController();
  TextEditingController store_district = TextEditingController();
  TextEditingController store_province = TextEditingController();
  File? image;
  bool statusLoading = false;
  String? user_id;
  List storeList = [];

  Future get_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
  }

  add_store() async {
    final uri = Uri.parse("$ipcon/api/store/add_store.php");
    var request = http.MultipartRequest('POST', uri);
    var img = await http.MultipartFile.fromPath("img", image!.path);

    request.files.add(img);
    request.fields['user_id'] = user_id.toString();
    request.fields['store_name'] = store_name.text;
    request.fields['store_phone'] = store_phone.text;
    request.fields['store_sub_district'] = store_sub_district.text;
    request.fields['store_district'] = store_sub_district.text;
    request.fields['store_province'] = store_province.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print(responseBody);
      get_store();
    }
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
    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('store_id', storeList[0]['store_id']);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomeStoreScreen();
      }));
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
    get_user();
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
            text: 'เพิ่มร้านค้า',
          ),
        ),
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: height * 0.018),
                  buildImage(),
                  buildBox("ชื่อร้าน", store_name),
                  buildBox("โทรศัพท์", store_phone),
                  buildBox("ตำบล", store_sub_district),
                  buildBox("อำเภอ", store_district),
                  buildBox("จังหวัด", store_province),
                  buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        pickImage();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        child: Container(
            height: height * 0.17,
            decoration: BoxDecoration(
              image: image == null
                  ? null
                  : DecorationImage(
                      fit: BoxFit.contain, image: FileImage(image!)),
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: Center(
                child: image == null
                    ? Icon(
                        Icons.image,
                        size: width * 0.12,
                      )
                    : SizedBox())),
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
          SizedBox(height: height * 0.01),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
              return null;
            },
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
          margin: EdgeInsets.symmetric(vertical: height * 0.02),
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
              final isValid = formKey.currentState!.validate();
              if (isValid) {
                if (image != null) {
                  add_store();
                } else {
                  Toast_Custom("กรุณาเลือกรูปภาพ", Colors.red);
                }
              }
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
