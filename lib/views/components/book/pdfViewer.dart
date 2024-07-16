import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pustaka/data/services/pdf_service.dart';

class PdfScreen extends StatefulWidget {
  final String bookUuid;
  final String pdfPath;
  final String title;

  PdfScreen(
      {required this.bookUuid, required this.pdfPath, required this.title});

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  PDFViewController? _pdfViewController;
  int _currentPage = 0;
  int _totalPages = 0;
  String? _pdfPath;
  bool _isLoading = true;
  bool _isNightMode = false;
  bool _isSwipeHorizontal = true;
  final storage = FlutterSecureStorage();
  Key _pdfViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      await _loadLastPage();
      await _loadPdfPath();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to initialize PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPdfPath() async {
    try {
      String _filePdf = await downloadPdf(widget.bookUuid, widget.pdfPath);
      setState(() {
        _pdfPath = _filePdf;
      });
    } catch (e) {
      print('Failed to load PDF path: $e');
      throw e;
    }
  }

  Future<void> _loadLastPage() async {
    String? lastRead = await storage.read(key: 'book_${widget.bookUuid}');
    setState(() {
      _currentPage = lastRead != null ? int.parse(lastRead) : 0;
    });
    print('Loaded page: $_currentPage');
  }

  Future<void> _saveLastPage(int page) async {
    await storage.write(key: 'book_${widget.bookUuid}', value: page.toString());
    print('Saved last page: $page');
  }

  @override
  void dispose() {
    _saveLastPage(_currentPage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pdfPath == null
              ? Center(child: Text("Failed to load PDF"))
              : Stack(
                  children: [
                    PDFView(
                      key: _pdfViewKey,
                      filePath: _pdfPath!,
                      autoSpacing: true,
                      pageFling: true,
                      pageSnap: true,
                      preventLinkNavigation: true,
                      swipeHorizontal: _isSwipeHorizontal,
                      nightMode: _isNightMode,
                      onRender: (pages) {
                        setState(() {
                          _totalPages = pages!;
                        });
                      },
                      onViewCreated:
                          (PDFViewController pdfViewController) async {
                        _pdfViewController = pdfViewController;
                        if (_currentPage != 0) {
                          await _pdfViewController?.setPage(_currentPage);
                        }
                      },
                      onPageChanged: (int? page, int? total) {
                        setState(() {
                          _currentPage = page!;
                        });
                        // _saveLastPage(_currentPage);
                      },
                      defaultPage: _currentPage,
                    ),
                    _isNightMode
                        ? Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              '${_currentPage + 1}/${_totalPages}',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )
                        : Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              '${_currentPage + 1}/${_totalPages}',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          )
                  ],
                ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green,
        children: [
          SpeedDialChild(
            child: Icon(Icons.bookmark),
            backgroundColor: Colors.red,
            label: 'Bookmark',
            onTap: () {
              _saveLastPage(_currentPage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Page ${_currentPage + 1} bookmarked')),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.brightness_6),
            backgroundColor: Colors.blue,
            label: 'Night Mode',
            onTap: () {
              setState(() {
                _isNightMode = !_isNightMode;
                _pdfViewKey = UniqueKey();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Night mode ${_isNightMode ? 'enabled' : 'disabled'}')),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.swap_horiz),
            backgroundColor: Colors.orange,
            label: 'Swipe Direction',
            onTap: () {
              setState(() {
                _isSwipeHorizontal = !_isSwipeHorizontal;
                // _pdfViewController;
                _pdfViewKey = UniqueKey();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Swipe direction ${_isSwipeHorizontal ? 'horizontal' : 'vertical'}')),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.pages),
            backgroundColor: Colors.purple,
            label: 'Go to Page',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Go to Page'),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        int page = int.parse(value);
                        if (page > 0 && page <= _totalPages) {
                          _pdfViewController?.setPage(page - 1);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Invalid page number: $page')),
                          );
                        }
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
