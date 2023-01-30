import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/screen/login_system/login_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zoo_app/screen/main_store_screen/setting_screen/store_setting/add_store_screen.dart';
import 'package:zoo_app/screen/main_store_screen/home_store_screen.dart';
import 'package:zoo_app/screen/main_user_screen/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? user_id;
  String? store_id;
  String? user_type;
  get_user_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
      store_id = preferences.getString('store_id');
      user_type = preferences.getString('user_type');
    });
    print("user_id : $user_id");
    print("store_id : $store_id");
    print("user_type : $user_type");
  }

  @override
  void initState() {
    get_user_id();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AnimatedSplashScreen(
      splash: Column(children: [
        CircleAvatar(
          backgroundColor: Color(0xffFDE3E2),
          radius: width * 0.23,
          backgroundImage: AssetImage('assets/image/logo.png'),
        ),
      ]),
      nextScreen: user_id == null ? LoginScreen()  : user_type == 'user'
              ? TabScreen()
              : store_id == null
                  ? AddStoreScreen()
                  : HomeStoreScreen(),
      splashIconSize: 200,
      backgroundColor: Color(0xffFDE3E2),
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
