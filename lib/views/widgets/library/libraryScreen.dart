import 'package:flutter/material.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/views/components/book/loan/index.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/data/models/loan.dart';
import 'package:pustaka/views/components/search.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _getService = GetService();
  int page = 1;
  BookList? _bookList;
  LoanList? _loanList;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchBooks();
    _fetchLoans();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchBooks() async {
    try {
      BookList bookList = await _getService.books(page.toString());
      setState(() {
        if (_bookList == null) {
          _bookList = bookList;
        } else {
          _bookList!.books.addAll(bookList.books);
        }
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed to load books $e'),
        ),
      );
    }
  }

  void _fetchLoans() async {
    try {
      LoanList loanList = await _getService.loan();
      setState(() {
        _loanList = loanList;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed to load loans $e'),
        ),
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        page++;
        _fetchBooks();
        _isLoadingMore = false;
      });
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
            Tab(text: '  Rekomendasi  '),
            Tab(text: '  PinjamanKu  '),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: Colors.black38,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: BookSearchDelegate(_bookList!.books));
            },
          ),
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
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                      bookUuid: book.uuid,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 0,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.network(
                                              book.image,
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
                          childCount: _bookList!.books.length,
                        ),
                      ),
                      if (_isLoadingMore)
                        SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          if (_loanList != null)
            loanBooks(
              context,
              _loanList!,
            )
          else
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
