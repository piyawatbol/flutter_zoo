import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/ipcon.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/animal_setting/add_animal.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/animal_setting/edit_animal_screen.dart';
import 'package:zoo_app/widget/color.dart';
import 'package:zoo_app/widget/custom_text.dart';

class AnimalSettingScreen extends StatefulWidget {
  const AnimalSettingScreen({super.key});

  @override
  State<AnimalSettingScreen> createState() => _AnimalSettingScreenState();
}

class _AnimalSettingScreenState extends State<AnimalSettingScreen> {
  List zooList = [];
  String? store_id;

  Future get_zoo_store() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    var url = Uri.parse('$ipcon/api/zoo/get_zoo_store.php');
    var response = await http.post(url, body: {
      "store_id": store_id,
    });
    var data = json.decode(response.body);
    setState(() {
      zooList = data;
    });
  }

  @override
  void initState() {
    get_zoo_store();
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
          text: "ตั้งค่าสัตว์เลี้ยง",
          fontSize: 20,
          color: Colors.white,
          fontWeight: null,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AddAnimalScreen();
                })).then((value) => get_zoo_store());
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [buildAnimal()],
          ),
        ),
      ),
    );
  }

  Widget buildAnimal() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.62,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: zooList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return EditAnimalScreen(
                    zoo_id: '${zooList[index]['zoo_id']}',
                  );
                })).then((value) => get_zoo_store());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0.2,
                        blurRadius: 2,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            height: height * 0.23,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "$ipcon/animal_img/${zooList[index]['zoo_img']}"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.019,
                                horizontal: width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Custom_text(
                                  text: "${zooList[index]['zoo_name']}",
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: null,
                                ),
                                Custom_text(
                                  text:
                                      "นำเข้า : ${zooList[index]['zoo_import']}",
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  fontWeight: null,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            width: width * 0.2,
                            height: height * 0.025,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                color: pink2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 3),
                                Custom_text(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: null,
                                  text: '${zooList[index]['zoo_province']} ',
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              width: width * 0.08,
                              height: height * 0.035,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: zooList[index]['zoo_sex'] == "ผู้"
                                  ? Image.asset(
                                      "assets/image/male.png",
                                    )
                                  : zooList[index]['zoo_sex'] == "เมีย"
                                      ? Image.asset(
                                          "assets/image/female.png",
                                          color: Colors.red,
                                        )
                                      : Text("")),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: width * 0.21,
                          height: height * 0.035,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                  topLeft: Radius.circular(10)),
                              color: pink2),
                          child: Center(
                            child: Custom_text(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: null,
                              text: '${zooList[index]['zoo_price']} ฿',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
