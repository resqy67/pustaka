import 'package:flutter/material.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/views/components/card.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/services/post_service.dart';
import 'package:pustaka/data/models/book.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _getService = GetService();
  int page = 1;
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
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchBooks();
    _postToken();
    _searchController.addListener(_onSearchChanged);
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
              ],
            ),
          ),
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
              : Center(
                  child: CircularProgressIndicator(),
                ),
          if (isLoading) Center(child: CircularProgressIndicator())
        ]),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final List<Book> books;

  BookSearchDelegate(this.books);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookPage(bookUuid: book.uuid),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookPage(bookUuid: book.uuid),
              ),
            );
          },
        );
      },
    );
  }
}
