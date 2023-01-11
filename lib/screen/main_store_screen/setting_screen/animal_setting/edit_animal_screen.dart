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
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';
import 'package:zoo_app/widget/inputsytle.dart';
import 'package:zoo_app/widget/loading_screen.dart';
import 'package:zoo_app/widget/toast_custom.dart';

class EditAnimalScreen extends StatefulWidget {
  String? zoo_id;
  EditAnimalScreen({required this.zoo_id});

  @override
  State<EditAnimalScreen> createState() => _EditAnimalScreen();
}

class _EditAnimalScreen extends State<EditAnimalScreen> {
  final formKey = GlobalKey<FormState>();
  File? image;
  String? store_id;
  List zooList = [];
  TextEditingController? zoo_name;
  TextEditingController? zoo_import;
  TextEditingController? zoo_price;
  TextEditingController? zoo_sex;
  TextEditingController? zoo_province;
  TextEditingController? zoo_type;
  TextEditingController? zoo_farm;
  TextEditingController? zoo_license;
  TextEditingController? zoo_brithday;
  TextEditingController? zoo_detail;
  TextEditingController? zoo_age;
  bool statusLoading = false;
  String? user_id;

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

  get_zoo_one() async {
    final response = await http.get(
        Uri.parse("$ipcon/api/zoo/get_zoo_one.php?zoo_id=${widget.zoo_id}"));
    var data = json.decode(response.body);

    setState(() {
      zooList = data;
    });
    zoo_name = TextEditingController(text: '${zooList[0]['zoo_name']}');
    zoo_import = TextEditingController(text: '${zooList[0]['zoo_import']}');
    zoo_price = TextEditingController(text: '${zooList[0]['zoo_price']}');
    zoo_sex = TextEditingController(text: '${zooList[0]['zoo_sex']}');
    zoo_type = TextEditingController(text: '${zooList[0]['zoo_type']}');
    zoo_farm = TextEditingController(text: '${zooList[0]['zoo_farm']}');
    zoo_province = TextEditingController(text: '${zooList[0]['zoo_province']}');
    zoo_license = TextEditingController(text: '${zooList[0]['zoo_license']}');
    zoo_brithday = TextEditingController(text: '${zooList[0]['zoo_brithday']}');
    zoo_detail = TextEditingController(text: '${zooList[0]['zoo_detail']}');
    zoo_age = TextEditingController(text: '${zooList[0]['zoo_age']}');
  }

  edit_zoo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final uri = Uri.parse("$ipcon/api/zoo/edit_zoo.php");
    var request = http.MultipartRequest('POST', uri);
    if (image != null) {
      var img = await http.MultipartFile.fromPath("img", image!.path);
      request.files.add(img);
    }
    request.fields['zoo_id'] = widget.zoo_id.toString();
    request.fields['zoo_name'] = zoo_name!.text;
    request.fields['zoo_import'] = zoo_import!.text;
    request.fields['zoo_price'] = zoo_price!.text;
    request.fields['zoo_sex'] = zoo_sex!.text;
    request.fields['zoo_type'] = zoo_type!.text;
    request.fields['zoo_farm'] = zoo_farm!.text;
    request.fields['zoo_province'] = zoo_province!.text;
    request.fields['zoo_license'] = zoo_license!.text;
    request.fields['zoo_brithday'] = zoo_brithday!.text;
    request.fields['zoo_detail'] = zoo_detail!.text;
    request.fields['zoo_age'] = zoo_age!.text;

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

  delete_zoo() async {
    final response = await http.get(
        Uri.parse("$ipcon/api/zoo/delete_zoo.php?zoo_id=${widget.zoo_id}"));
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    get_zoo_one();
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
          text: "แก้ไขสัตว์เลี้ยง",
          fontSize: 20,
          color: Colors.white,
          fontWeight: null,
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {
                  _showModalBottomSheet();
                },
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: zooList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        buildImg(),
                        buildBox("ชื่อสัตว์", zoo_name),
                        buildBox("นำเข้า", zoo_import),
                        buildBox("ราคา", zoo_price),
                        buildBox("เพศ", zoo_sex),
                        buildBox("จังหวัด", zoo_province),
                        buildBox("ชนิด", zoo_type),
                        buildBox("ฟาร์ม", zoo_farm),
                        buildBox("ใบเลขที่นำเข้า", zoo_license),
                        buildBox("วันเกิด", zoo_brithday),
                        buildBox("รายละเอียด", zoo_detail),
                        buildBox("อายุ", zoo_age),
                        buildSaveButton()
                      ],
                    ),
                    LoadingScreen(statusLoading: statusLoading)
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildImg() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        pickImage();
      },
      child: Container(
          margin: EdgeInsets.symmetric(
              vertical: height * 0.015, horizontal: width * 0.03),
          width: width,
          height: height * 0.25,
          decoration: BoxDecoration(color: Colors.grey.shade300),
          child: image != null
              ? Image.file(
                  image!,
                  fit: BoxFit.contain,
                )
              : Image.network(
                  "$ipcon/animal_img/${zooList[0]['zoo_img']}",
                  fit: BoxFit.contain,
                )),
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
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
              return null;
            },
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
              edit_zoo();
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
                text: 'ต้องการลบหรือไม่?',
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
                        delete_zoo();
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
                        setState(() {
                          statusLoading = true;
                        });
                        edit_zoo();
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
