import 'package:flutter/material.dart';
import 'package:zoo_app/screen/main_user_screen/home_screen/home_screen.dart';
import 'package:zoo_app/screen/main_user_screen/noti_screen/noti_screen.dart';
import 'package:zoo_app/screen/main_user_screen/profile_screen/profile_screen.dart';
import 'package:zoo_app/screen/main_user_screen/star_screen/star_screen.dart';
import 'package:zoo_app/widget/color.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentIndex = 0;
  final screens = [HomeScreen(), StarScreen(), NotiScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: pink,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        iconSize: 30,
        selectedFontSize: 12,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificatios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
