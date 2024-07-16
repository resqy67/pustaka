import 'package:flutter/material.dart';
import 'package:pustaka/data/models/users.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:pustaka/data/services/post_service.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/views/components/book/pdfViewer.dart';
import 'package:pustaka/data/services/pdf_service.dart';
// import 'package:dio/dio.dart';

class BookPage extends StatefulWidget {
  final String bookUuid;

  const BookPage({Key? key, required this.bookUuid}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final GetService _getService = GetService();
  final AuthService _authService = AuthService();
  final PostService _postService = PostService();
  Book? _book;
  GetUser? _getUser;
  bool isAvailable = false;
  bool isBorrowedByUser = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBook();
    _fetchUser();
  }

  void _fetchBook() async {
    try {
      Book book = await _getService.book(widget.bookUuid);
      setState(() {
        _book = book;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed to load book $e'),
        ),
      );
    }
  }

  void _fetchUser() async {
    try {
      GetUser getUser = await _authService.getUser();
      setState(() {
        _getUser = getUser;
      });
      final response = await _getService.checkAvailable(
        bookUuid: widget.bookUuid,
        userId: _getUser!.id,
      );
      print(response);
      if (response['status'] == 'success') {
        setState(() {
          isAvailable = true;
          isBorrowedByUser = false;
          isLoading = false;
        });
      } else if (response['status'] == 'info') {
        setState(() {
          isAvailable = false;
          isBorrowedByUser = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isAvailable = false;
          isBorrowedByUser = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _postLoan() async {
    try {
      final response = await _postService.loanStore(
        bookUuid: widget.bookUuid,
        userId: _getUser!.id,
      );
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buku berhasil dipinjam'),
          ),
        );
        setState(() {
          isAvailable = false;
          isBorrowedByUser = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal meminjam buku'),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal meminjam buku $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String buttonText;
    VoidCallback? onPressed;
    if (isAvailable) {
      buttonText = 'Pinjam';
      onPressed = _postLoan;
    } else if (isBorrowedByUser) {
      buttonText = 'Baca Buku';
      onPressed = () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfScreen(
                    bookUuid: _book!.uuid,
                    pdfPath: _book!.filepdf,
                    title: _book!.title)));
      };
    } else {
      buttonText = 'Sudah Dipinjam';
      onPressed = null;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _book == null ? 'Loading...' : _book!.title,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _book == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(top: 10),
                      child: Image.network(
                        _book!.image,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _book!.title,
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            _book!.author.length > 20
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.only(top: 17),
                                    child: Icon(
                                      Icons.person_2_rounded,
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(16),
                                    child: Icon(
                                      Icons.person_2_rounded,
                                      color: Colors.black,
                                    ),
                                  ),
                            const SizedBox(height: 4),
                            _book!.author.length > 20
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: Text(
                                        _book!.author,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _book!.author,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ],
                        ),
                        // SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Icon(Icons.access_time_filled_rounded,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _book!.availability.toString() == '1'
                                  ? 'Tersedia'
                                  : 'Tidak Tersedia',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Icon(Icons.my_library_books_outlined,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _book!.loan_count + ' Pembaca',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sinopsis',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _book!.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Detail Buku',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildDetailRow('Penerbit', _book!.publisher),
                              SizedBox(height: 10),
                              buildDetailRow('ISBN', _book!.isbn),
                              SizedBox(height: 10),
                              buildDetailRow(
                                  'Tahun',
                                  _book!.year
                                      .toString()), // Convert year to string
                              SizedBox(height: 10),
                              buildDetailRow(
                                  'Halaman',
                                  _book!.pages
                                      .toString()), // Convert pages to string
                              SizedBox(height: 10),
                              buildDetailRow(
                                  'Kategori',
                                  _book!.categories
                                      .join(', ')), // Convert list to string
                            ],
                          ),
                        ],
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(300, 50),
                      ),
                      onPressed: onPressed,
                      child: Text(buttonText)),
                  SizedBox(height: 20)
                ],
              ),
            ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100, // Sesuaikan lebar label sesuai kebutuhan Anda
          child: Text(
            '$label',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
          child: Text(
            ':   $value',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
