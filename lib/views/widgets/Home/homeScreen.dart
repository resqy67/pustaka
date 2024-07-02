import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pustaka/views/components/card.dart';
import 'package:pustaka/data/services/auth_service.dart';
// import 'package:pustaka/controller/TabController.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Good Morning, User!',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: Colors.black38,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.black38,
                size: 30,
              ))
        ],
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, left: 25, bottom: 10),
              child: Text(
                'Buku Terbaru',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorWeight: 0,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green[50],
                ),
                labelPadding:
                    EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.green[600],
                unselectedLabelColor: Colors.black38,
                tabs: <Widget>[
                  Tab(
                    text: '  Terbaru  ',
                  ),
                  Tab(
                    text: '  Disarankan  ',
                  ),
                  // Tab(
                  //   text: '  New Release  ',
                  // ),
                  // Tab(
                  //   text: '  Recommended  ',
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: 340,
                height: 200,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CardWidget(),
                          CardWidget(),
                          CardWidget(),
                          CardWidget(),
                          CardWidget(),
                        ],
                      ),
                    ),
                    Container(
                      child: CardWidget(),
                    ),
                    // Container(
                    //   child: Text('New Release'),
                    // ),
                    // Container(
                    //   child: Text('Recommended'),
                    // ),
                  ],
                )),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, left: 25, bottom: 10),
              child: Text(
                'Mungkin Kamu Suka',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(10, (index) {
                  return Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        15, // Lebar setengah dari layar dengan jarak antar item
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                'https://picsum.photos/200/320',
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thinking, Fast and Slow',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'James Clear',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
