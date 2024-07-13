import 'package:flutter/material.dart';
import 'package:pustaka/data/models/users.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/views/components/card.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/services/post_service.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/views/components/search.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _getService = GetService();
  final AuthService _authService = AuthService();
  int page = 1;
  GetUser? _getUser;
  List<Book> _bookList = [];
  List<Book> _searchResults = [];
  late ScrollController _scrollController;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  void _postToken() async {
    final _postService = PostService();
    _postService.updateTokenFcm();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchBooks();
    _postToken();
    _searchController.addListener(_onSearchChanged);
    _fetchUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = _bookList
          .where((book) => book.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _fetchUser() async {
    try {
      GetUser getUser = await _authService.getUser();
      setState(() {
        _getUser = getUser;
      });
      print('ini nama usesrnya ${_getUser?.name}');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('failed to get user')));
    }
  }

  void _fetchBooks() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      BookList bookList = await _getService.books(page.toString());
      setState(() {
        _bookList.addAll(bookList.books);
        _searchResults = _bookList;
        page++;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load books: $e'),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            _getUser != null
                ? Text(
                    'Hallo, ${_getUser!.name}',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : Text('Hallo',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold)),
          ],
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 20),
            icon: Icon(
              Icons.search_outlined,
              color: Colors.black38,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(_bookList),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(children: <Widget>[
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
          // Container(
          //   child: TabBar(
          //     controller: _tabController,
          //     isScrollable: true,
          //     tabAlignment: TabAlignment.start,
          //     indicatorWeight: 0,
          //     indicator: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       color: Colors.green[50],
          //     ),
          //     labelPadding:
          //         EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
          //     overlayColor: MaterialStateProperty.all(Colors.transparent),
          //     labelStyle: TextStyle(
          //       fontSize: 15,
          //       fontFamily: 'Poppins',
          //       fontWeight: FontWeight.bold,
          //     ),
          //     labelColor: Colors.green[600],
          //     unselectedLabelColor: Colors.black38,
          //     tabs: <Widget>[
          //       Tab(
          //         text: '  Terbaru  ',
          //       ),
          //       // Tab(
          //       //   text: '  Disarankan  ',
          //       // ),
          //     ],
          //   ),
          // ),
          _bookList.isEmpty
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                )
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  items: _bookList
                      .take(10)
                      .map((book) => CardWidget(
                            title: book.title.length > 60
                                ? book.title.substring(0, 60) + "..."
                                : book.title,
                            description: book.description.length > 50
                                ? book.description.substring(0, 50) + "..."
                                : book.description,
                            author: book.author.length > 18
                                ? book.author.substring(0, 18) + "..."
                                : book.author,
                            year: book.year,
                            imageUrl: 'https://picsum.photos/200/300',
                            bookUuid: book.uuid,
                          ))
                      .toList(),
                ),
          SizedBox(
            height: 10,
          ),
          // Container(
          //   width: 340,
          //   height: 200,
          //   child: TabBarView(
          //     controller: _tabController,
          //     children: <Widget>[
          //       SingleChildScrollView(
          //           scrollDirection: Axis.horizontal,
          //           child: _bookList == null || _bookList.isNotEmpty              ? Row(
          //                   children: _bookList.take(3).map((book) {
          //                     return CardWidget(
          //                       title: book.title.length > 60 ? book.title.substring(0, 60) + "..."
          //                           : book.title,
          //                       description: book.description.length > 50
          //                          d ? book.description.substring(0, 50) + "..."
          //                           : book.description,
          //                       author: book.author.length > 18
          //                         d  ? book.author.substring(0, 18) + "..."
          //                           : book.author,
          //                       year: book.year,
          //                       // rating: 4.5, // Add actual rating if available
          //                       imageUrl: 'https://picsum.photos/200/300',
          //                       bookUuid: book.uuid,
          //                     );
          //                   }).toList(),
          //                 )
          //               : Shimmer.fromColors(
          //                   baseColor: Colors.grey[300]!,
          //                   highlightColor: Colors.grey[100]!,
          //                   child: Container(
          //                     width: 600,
          //                     height: 400,
          //                     color: Colors.grey[300],
          //                   ))),
          //     ],
          //   ),
          // ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 5, left: 25, bottom: 10),
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
          _bookList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _bookList.map((item) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 15,
                        height: 300,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                splashColor: Colors.grey,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookPage(bookUuid: item.uuid)));
                                },
                                child: Card(
                                  elevation: 0,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                        item.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title.length > 60
                                          ? item.title.substring(0, 55) + "..."
                                          : item.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      item.author,
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
                      );
                    }).toList(),
                  ),
                )
              // : Center(
              //     child: CircularProgressIndicator(),
              //   ),
              : Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          height: 300,
                          child: Card(
                            color: Colors.grey[300],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          height: 300,
                          child: Card(
                            color: Colors.grey[300],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          height: 300,
                          child: Card(color: Colors.grey[300]),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          height: 300,
                          child: Card(
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  )),
          if (isLoading) Center(child: CircularProgressIndicator())
        ]),
      ),
    );
  }
}
