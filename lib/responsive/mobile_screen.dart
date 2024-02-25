import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _currentIndex = 0;

  void changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => changeIndex(index),
        backgroundColor: mobileBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color.fromARGB(220, 255, 255, 255),
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          // HOME
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          // SEARCH
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
          // ADD
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Add',
          ),
          // FAVORITE
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            label: 'Favorite',
          ),
          // PERSON
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Person',
              activeIcon: Icon(Icons.person_2_sharp)),
        ],
      ),
    );
  }
}
