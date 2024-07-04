import 'package:flutter/material.dart';
import 'package:pustaka/views/components/book/gridBooks.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/views/components/book/loan/index.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/models/book.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _getService = GetService();
  BookList? _bookList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fecthBooks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fecthBooks() async {
    try {
      // BookList bookList = await _getService.books();
      BookList bookList = await _getService.books();
      setState(() {
        _bookList = bookList;
      });
      print(bookList);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed to load books $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          indicatorWeight: 0,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green[50],
          ),
          labelPadding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
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
              text: '  Rekomendasi  ',
            ),
            // Tab(
            //   text: '  Lihat Buku  ',
            // ),
            Tab(
              text: '  PinjamanKu  ',
            )
          ],
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
      body: TabBarView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: _bookList != null
                  ? CustomScrollView(
                      slivers: <Widget>[
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent:
                                MediaQuery.of(context).size.width - 50,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, index) {
                              Book book = _bookList!.books[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookPage(
                                          // book: book,
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width / 2 -
                                    //         15,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Card(
                                          elevation: 0,
                                          // clipBehavior: Clip.antiAlias,
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(10)),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.network(
                                                book.image,
                                                // 'https://picsum.photos/200/320',
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // 'Thinking, Fast and Slow',
                                                book.title,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                // 'James Clear',
                                                book.author,
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
                                  ),
                                ),
                              );
                            },
                            childCount: _bookList!.books
                                .length, // Ganti jumlah item sesuai kebutuhan
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
          // Konten untuk tab lainnya
          // gridBooks(context),
          loanBooks(context),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: LibraryScreen(),
//   ));
// }
