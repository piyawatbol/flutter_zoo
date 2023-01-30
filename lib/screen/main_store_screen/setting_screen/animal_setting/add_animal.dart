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

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final formKey = GlobalKey<FormState>();
  File? image;
  String? store_id;

  TextEditingController zoo_name = TextEditingController();
  TextEditingController zoo_import = TextEditingController();
  TextEditingController zoo_price = TextEditingController();
  TextEditingController zoo_sex = TextEditingController();
  TextEditingController zoo_province = TextEditingController();
  TextEditingController zoo_type = TextEditingController();
  TextEditingController zoo_farm = TextEditingController();
  TextEditingController zoo_license = TextEditingController();
  TextEditingController zoo_brithday = TextEditingController();
  TextEditingController zoo_detail = TextEditingController();
  TextEditingController zoo_age = TextEditingController();
  bool statusLoading = false;

  add_animal() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });

    final uri = Uri.parse("$ipcon/api/zoo/add_zoo.php");
    var request = http.MultipartRequest('POST', uri);
    var img = await http.MultipartFile.fromPath("img", image!.path);
    request.files.add(img);
    request.fields['store_id'] = store_id.toString();
    request.fields['zoo_name'] = zoo_name.text;
    request.fields['zoo_import'] = zoo_import.text;
    request.fields['zoo_price'] = zoo_price.text;
    request.fields['zoo_sex'] = zoo_sex.text;
    request.fields['zoo_type'] = zoo_type.text;
    request.fields['zoo_farm'] = zoo_farm.text;
    request.fields['zoo_province'] = zoo_province.text;
    request.fields['zoo_license'] = zoo_license.text;
    request.fields['zoo_brithday'] = zoo_brithday.text;
    request.fields['zoo_detail'] = zoo_detail.text;
    request.fields['zoo_age'] = zoo_age.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      final responseBody = await response.stream.bytesToString();
      print(responseBody);
      Navigator.pop(context);
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          elevation: 1,
          title: Custom_text(
            text: "เพิ่มสัตว์เลี้ยง",
            fontSize: 20,
            color: Colors.white,
            fontWeight: null,
          ),
        ),
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
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
          child: image == null
              ? Icon(
                  Icons.add,
                  color: Colors.white,
                )
              : Image.file(
                  image!,
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
              final isValid = formKey.currentState!.validate();
              if (isValid) {
                if (image != null) {
                  setState(() {
                    statusLoading = true;
                  });
                  add_animal();
                } else {
                  Toast_Custom("กรุณาเลือกรูป", Colors.red);
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
