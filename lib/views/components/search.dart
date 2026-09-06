import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/data/models/book.dart';

class BookSearchDelegate extends SearchDelegate {
  final List<Book> books;

  BookSearchDelegate(this.books)
      : super(
          searchFieldLabel: 'Cari judul buku...',
          searchFieldStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            color: Colors.black87,
          ),
        );

  // Kustomisasi tema AppBar pencarian biar lebih clean dan modern
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.black38),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.black54),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black87),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _DebouncedSearchBody(
      query: query,
      books: books,
      isSuggestion: false,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _DebouncedSearchBody(
      query: query,
      books: books,
      isSuggestion: true,
    );
  }
}

// ============================================================================
// WIDGET KHUSUS UNTUK DEBOUNCE & RENDER HASIL PENCARIAN
// ============================================================================
class _DebouncedSearchBody extends StatefulWidget {
  final String query;
  final List<Book> books;
  final bool isSuggestion;

  const _DebouncedSearchBody({
    Key? key,
    required this.query,
    required this.books,
    required this.isSuggestion,
  }) : super(key: key);

  @override
  State<_DebouncedSearchBody> createState() => _DebouncedSearchBodyState();
}

class _DebouncedSearchBodyState extends State<_DebouncedSearchBody> {
  Timer? _debounce;
  late String _currentQuery;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
  }

  @override
  void didUpdateWidget(covariant _DebouncedSearchBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika user mengetik (query berubah), batalkan timer lama, buat timer baru
    if (oldWidget.query != widget.query) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _currentQuery = widget.query;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Bersihkan timer saat widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter buku berdasarkan query yang sudah di-debounce
    final results = widget.books
        .where((book) =>
            book.title.toLowerCase().contains(_currentQuery.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Buku tidak ditemukan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: const Color(0xFFF8F9FA), // Background super muda biar elegan
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: results.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Colors.black12,
          indent: 72, // Garis divider disesuaikan dengan posisi teks
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final book = results[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            // Ikon dibungkus lingkaran ala UI Modern
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isSuggestion ? Icons.history : Icons.book,
                color: Colors.green[700],
                size: 20,
              ),
            ),
            title: Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: const Icon(
              Icons.arrow_outward,
              color: Colors.black38,
              size: 20,
            ),
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
      ),
    );
  }
}
