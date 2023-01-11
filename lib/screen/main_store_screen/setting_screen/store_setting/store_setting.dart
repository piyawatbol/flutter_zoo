import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/inputsytle.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class StoreSettingScreen extends StatefulWidget {
  const StoreSettingScreen({super.key});

  @override
  State<StoreSettingScreen> createState() => _StoreSettingScreenState();
}

class _StoreSettingScreenState extends State<StoreSettingScreen> {
  TextEditingController? store_name;
  TextEditingController? store_phone;
  TextEditingController? store_ig;
  TextEditingController? store_link_ig;
  TextEditingController? store_line;
  TextEditingController? store_link_line;
  TextEditingController? store_sub_district;
  TextEditingController? store_district;
  TextEditingController? store_province;

  List storeList = [];
  String? user_id;
  File? image;
  bool statusLoading = false;

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
    store_name = TextEditingController(text: '${storeList[0]['store_name']}');
    store_phone = TextEditingController(text: '${storeList[0]['store_phone']}');
    store_ig = TextEditingController(text: '${storeList[0]['store_ig']}');
    store_link_ig =
        TextEditingController(text: '${storeList[0]['store_link_ig']}');
    store_line = TextEditingController(text: '${storeList[0]['store_line']}');
    store_link_line =
        TextEditingController(text: '${storeList[0]['store_link_line']}');
    store_sub_district =
        TextEditingController(text: '${storeList[0]['store_sub_district']}');
    store_district =
        TextEditingController(text: '${storeList[0]['store_district']}');
    store_province =
        TextEditingController(text: '${storeList[0]['store_province']}');
  }

  edit_store() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final uri = Uri.parse("$ipcon/api/store/edit_store.php");
    var request = http.MultipartRequest('POST', uri);
    if (image != null) {
      var img = await http.MultipartFile.fromPath("img", image!.path);
      request.files.add(img);
    }
    request.fields['user_id'] = user_id.toString();
    request.fields['store_name'] = store_name!.text;
    request.fields['store_phone'] = store_phone!.text;
    request.fields['store_ig'] = store_ig!.text;
    request.fields['store_link_ig'] = store_link_ig!.text;
    request.fields['store_line'] = store_line!.text;
    request.fields['store_link_line'] = store_link_line!.text;
    request.fields['store_sub_district'] = store_sub_district!.text;
    request.fields['store_district'] = store_district!.text;
    request.fields['store_province'] = store_province!.text;

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

  @override
  void initState() {
    get_store();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        elevation: 1,
        title: Custom_text(
          text: "ตั้งค่าร้านค้า",
          fontSize: 20,
          color: Colors.white,
          fontWeight: null,
        ),
      ),
      body: storeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildImg(),
                    buildBox("ชื่อร้าน", store_name),
                    buildBox("เบอร์โทรศัพท์", store_phone),
                    buildBox("Instragram", store_ig),
                    buildBox("Line", store_line),
                    buildBox("ตำบล", store_sub_district),
                    buildBox("อำเภอ", store_district),
                    buildBox("จังหวัด", store_province),
                    buildSaveButton()
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildImg() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.03),
            child: image == null
                ? CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: width * 0.18,
                    backgroundImage: NetworkImage(
                        '$ipcon/store_img/${storeList[0]['store_img']}'),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: width * 0.18,
                    backgroundImage: FileImage(image!),
                  )),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: height * 0.1,
            width: width * 0.12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0.5,
                  blurRadius: 0.5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Icon(
                  Icons.edit,
                  color: pink,
                ),
              ),
            ),
          ),
        )
      ],
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
            fontSize: 16,
            fontWeight: FontWeight.w200,
            text: '$text1',
          ),
          SizedBox(height: height * 0.01),
          TextField(
            controller: controller,
            style: GoogleFonts.itim(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
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
          margin: EdgeInsets.symmetric(vertical: height * 0.03),
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
              edit_store();
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
