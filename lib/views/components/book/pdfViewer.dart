import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pustaka/data/services/pdf_service.dart';

class PdfScreen extends StatefulWidget {
  final String bookUuid;
  final String pdfPath;

  PdfScreen({required this.bookUuid, required this.pdfPath});

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  PDFViewController? _pdfViewController;
  int _currentPage = 0;
  int _totalPages = 0;
  String? _pdfPath;
  bool _isLoading = true;
  final storage = FlutterSecureStorage();

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
        title: Text("PDF Viewer"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pdfPath == null
              ? Center(child: Text("Failed to load PDF"))
              : Stack(children: [
                  PDFView(
                    filePath: _pdfPath!,
                    // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    //   Factory<OneSequenceGestureRecognizer>(
                    //     () => EagerGestureRecognizer(),
                    //   ),
                    // ].toSet(),
                    autoSpacing: true,
                    pageFling: true,
                    pageSnap: true,
                    preventLinkNavigation: true,
                    onRender: (pages) {
                      setState(() {
                        _totalPages = pages!;
                      });
                    },
                    onViewCreated: (PDFViewController pdfViewController) async {
                      _pdfViewController = pdfViewController;
                      if (_currentPage != 0) {
                        await _pdfViewController?.setPage(_currentPage);
                      }
                    },
                    onPageChanged: (int? page, int? total) {
                      setState(() {
                        _currentPage = page!;
                      });
                      _saveLastPage(_currentPage);
                    },
                    defaultPage: _currentPage,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Text(
                      '$_currentPage/$_totalPages',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ]),
    );
  }
}
