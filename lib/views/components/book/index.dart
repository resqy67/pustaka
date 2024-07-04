import 'package:flutter/material.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/views/components/book/pdfViewer.dart';
import 'package:pustaka/data/services/pdf_service.dart';

class BookPage extends StatefulWidget {
  final String bookUuid;

  const BookPage({Key? key, required this.bookUuid}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final GetService _getService = GetService();
  Book? _book;

  @override
  void initState() {
    super.initState();
    _fetchBook();
  }

  void _fetchBook() async {
    try {
      // print('fetching book ${widget.bookUuid}');
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
  // List<String> categoryNames =
  //     _book!.categories.map((category) => category['name']).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Page'),
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
                      // margin: EdgeInsets.only(top: 20),
                      child: Image.network(
                        _book!.image,
                        // 'https://picsum.photos/200/320',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _book!.title,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_book!.author,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            )),
                        Text(' | ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w200,
                            )),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 20,
                          weight: 20,
                        ),
                        Text('4.5',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              clipBehavior: Clip.antiAlias,
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .orange, // Replace 'primary' with 'backgroundColor'
                                // fixedSize: Size(50, 50),
                              ),
                              child: Icon(Icons.access_time_filled_rounded),
                            ),
                            if (_book!.availability == '1')
                              Text('Tersedia',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  )),
                            if (_book!.availability == '0')
                              Text('Tidak Tersedia',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  )),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            ElevatedButton(
                              clipBehavior: Clip.antiAlias,
                              onPressed: () {},
                              child: Icon(Icons.my_library_books_outlined),
                            ),
                            Text('31 Pembaca',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sinopsis',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _book!.description,
                            // '  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec odio. Donec et nunc nec nisl ultricies ultricies. Donec auctor, nunc nec Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec odio. Nullam vel sapien sit amet',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Detail Buku',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Penerbit: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(_book!.publisher,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('ISBN: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(_book!.isbn,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Tahun: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(_book!.year,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Halaman: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(_book!.pages,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Kategori: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(
                                  _book!.categories
                                      .join(', '), // Convert list to string
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ],
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(300, 50),
                      ),
                      onPressed: () async {
                        // String pdfPath =
                        //     await downloadPdf(_book!.uuid, _book!.filepdf);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         PdfViewer(path: _book!.filepdf),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfScreen(
                                  bookUuid: _book!.uuid,
                                  pdfPath: _book!.filepdf)),
                        );
                      },
                      child: Text('Pinjam Buku')),
                  SizedBox(height: 20)
                ],
              ),
            ),
    );
  }
}
