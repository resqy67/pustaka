import 'package:flutter/material.dart';

class TabControllerWidget extends StatefulWidget {
  final int length;
  final Widget Function(TabController) child;

  TabControllerWidget({required this.length, required this.child});

  @override
  _TabControllerWidgetState createState() => _TabControllerWidgetState();
}

class _TabControllerWidgetState extends State<TabControllerWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(_tabController);
  }
}
