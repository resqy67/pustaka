import 'package:flutter/material.dart';
import 'package:pustaka/views/widgets/account/accountScreen.dart';
import 'package:pustaka/views/widgets/library/libraryScreen.dart';
import 'package:pustaka/views/widgets/Home/homeScreen.dart';

Widget buildBody(int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      return HomeScreen();
    case 1:
      return LibraryScreen();
    case 2:
      return AccountScreen();
    default:
      return Container();
  }
}

Widget buildBottomNavigationBar(int selectedIndex, Function(int) onTabTapped) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_max_sharp),
        label: 'dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.library_add_sharp),
        label: 'Library',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_box_sharp),
        label: 'Account',
      ),
    ],
    currentIndex: selectedIndex,
    selectedItemColor: Colors.green[600],
    onTap: onTabTapped,
  );
}
