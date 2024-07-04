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
  late PDFViewController _pdfViewController;
  int _currentPage = 0;
  int _totalPages = 0;
  late String _pdfPath = '';
  bool _isLoading = true;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadLastPage();
    _loadPdfPath();
  }

  Future<void> _loadPdfPath() async {
    String _filePdf = await downloadPdf(widget.bookUuid, widget.pdfPath);
    setState(() {
      _pdfPath = _filePdf;
      _isLoading = false;
    });
  }

  Future<void> _loadLastPage() async {
    try {
      String? lastPageStr = await storage.read(key: 'book_${widget.bookUuid}');
      int lastPage = int.parse(lastPageStr ?? "0");
      setState(() {
        _currentPage = lastPage;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load last page: $e');
    }
  }

  Future<void> _saveLastPage(int page) async {
    try {
      await storage.write(
          key: 'book_${widget.bookUuid}', value: page.toString());
    } catch (e) {
      print('Failed to save last page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: _pdfPath,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              onRender: (pages) {
                setState(() {
                  _totalPages = pages!;
                  _isLoading = false;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) async {
                _pdfViewController = pdfViewController;
                try {
                  await _pdfViewController.setPage(_currentPage);
                } catch (e) {
                  print('Failed to set page: $e');
                }
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page ?? 0;
                });
                _saveLastPage(_currentPage);
              },
            ),
    );
  }
}
