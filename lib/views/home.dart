import 'package:flutter/material.dart';
import 'package:pustaka/views/components/bottomNavbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildBody(_currentIndex),
        bottomNavigationBar:
            buildBottomNavigationBar(_currentIndex, _onTabTapped));
  }
}
