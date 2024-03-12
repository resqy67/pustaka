import 'package:flutter/material.dart';
import 'package:pustaka/views/components/card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, left: 25, bottom: 10),
              child: Text(
                'Buku Terbaru',
                style: TextStyle(
                  fontSize: 35,
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
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.green[50],
                ),
                labelPadding:
                    EdgeInsets.only(left: 15, right: 10, top: 0, bottom: 0),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.green[600],
                unselectedLabelColor: Colors.black38,
                // indicatorColor: Colors.green,
                tabs: <Widget>[
                  Tab(
                    text: 'This Month',
                  ),
                  Tab(
                    text: 'Best Seller',
                  ),
                  Tab(
                    text: 'New Release',
                  ),
                  Tab(
                    text: 'Recommended',
                  )
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
                    Container(
                      child: CardWidget(
                        title: 'Buku 1',
                        description: 'Deskripsi Buku 1',
                        image:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png/200px-Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png',
                        onTap: () {},
                      ),
                    ),
                    Container(
                      child: Text('Best Seller'),
                    ),
                    Container(
                      child: Text('New Release'),
                    ),
                    Container(
                      child: Text('Recommended'),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
