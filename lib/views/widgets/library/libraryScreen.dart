import 'package:flutter/material.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/views/components/book/loan/index.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/data/models/loan.dart';
import 'package:pustaka/data/models/log_loan.dart';
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
  LoanHistoryList? _loanHistoryList;
  BookList? _bookList;
  LoanList? _loanList;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchBooks();
    _fetchLoans();
    _fetchLoanHistory();
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
      if (!mounted) return;
      setState(() {
        if (_bookList == null) {
          _bookList = bookList;
        } else {
          _bookList!.books.addAll(bookList.books);
        }
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load books: $e')),
      );
    }
  }

  void _fetchLoans() async {
    try {
      LoanList loanList = await _getService.loan();
      if (!mounted) return;
      setState(() {
        _loanList = loanList;
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load loans: $e')),
      );
    }
  }

  void _fetchLoanHistory() async {
    try {
      LoanHistoryList loanHistoryList = await _getService.loanHistory();
      if (!mounted) return;
      setState(() {
        _loanHistoryList = loanHistoryList;
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load loan history: $e')),
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
      });
      // Ambil data buku tanpa memblokir UI
      _getService.books(page.toString()).then((bookList) {
        if (!mounted) return;
        setState(() {
          _bookList?.books.addAll(bookList.books);
          _isLoadingMore = false;
        });
      }).catchError((e) {
        if (!mounted) return;
        setState(() => _isLoadingMore = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang modern
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Library',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          dividerColor: Colors
              .transparent, // Menghilangkan garis abu-abu tipis di bawah tab biar makin clean
          indicatorSize: TabBarIndicatorSize
              .tab, // <-- Kunci supaya background hijaunya melebar mengikuti tab
          indicatorPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 4), // <-- Jarak bernapas atas-bawah dan samping
          indicatorWeight: 0,
          indicator: BoxDecoration(
            borderRadius:
                BorderRadius.circular(25), // Dibuat lebih melengkung sempurna
            color: Colors.green.withOpacity(0.15),
          ),
          labelPadding: const EdgeInsets.symmetric(
              horizontal: 20), // Jarak spasi antar menu tab
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          labelColor: Colors
              .green[800], // Warnanya dipertajam sedikit biar lebih kontras
          unselectedLabelColor: Colors.grey[500],
          tabs: const <Widget>[
            Tab(text: 'Daftar Buku'),
            Tab(text: 'PinjamanKu'),
            Tab(text: 'Riwayat'),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.black54,
                size: 28,
              ),
              onPressed: () {
                if (_bookList != null) {
                  showSearch(
                    context: context,
                    delegate: BookSearchDelegate(_bookList!.books),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // --- TAB 1: DAFTAR BUKU ---
          _bookList != null
              ? CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62, // Otomatis menyesuaikan layar
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, index) {
                            Book book = _bookList!.books[index];
                            return GestureDetector(
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
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                        child: Image.network(
                                          book.image,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                                child: Icon(Icons.broken_image,
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            book.author,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: _bookList!.books.length,
                        ),
                      ),
                    ),
                    if (_isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),

          // --- TAB 2: PINJAMANKU ---
          _loanList != null
              ? loanBooks(context, _loanList!)
              : const Center(child: CircularProgressIndicator()),

          // --- TAB 3: RIWAYAT ---
          _loanHistoryList != null
              ? (_loanHistoryList!.loanHistories.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _loanHistoryList!.loanHistories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        LoanHistory loanHistory =
                            _loanHistoryList!.loanHistories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookPage(
                                  bookUuid: loanHistory.bookUuid,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Gambar Buku Riwayat
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    loanHistory.bookImage,
                                    width: 60,
                                    height: 85,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 60,
                                      height: 85,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.book,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Detail Buku
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loanHistory.bookTitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        loanHistory.bookAuthor,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Dikembalikan: ${loanHistory.returnDate}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Belum ada riwayat peminjaman',
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.grey),
                      ),
                    ))
              : const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
