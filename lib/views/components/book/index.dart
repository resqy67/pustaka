import 'package:flutter/material.dart';
import 'package:pustaka/data/models/users.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:pustaka/data/services/post_service.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/views/components/book/pdfViewer.dart';
// import 'package:pustaka/data/services/pdf_service.dart';

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
    _fetchData();
  }

  // Menggabungkan fetch agar loading statenya lebih rapi
  void _fetchData() async {
    try {
      Book book = await _getService.book(widget.bookUuid);
      GetUser getUser = await _authService.getUser();

      if (!mounted) return;
      setState(() {
        _book = book;
        _getUser = getUser;
      });

      final response = await _getService.checkAvailable(
        bookUuid: widget.bookUuid,
        userId: _getUser!.id,
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        setState(() {
          isAvailable = true;
          isBorrowedByUser = false;
        });
      } else if (response['status'] == 'info') {
        setState(() {
          isAvailable = false;
          isBorrowedByUser = true;
        });
      } else {
        setState(() {
          isAvailable = false;
          isBorrowedByUser = false;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data buku: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
          const SnackBar(content: Text('Buku berhasil dipinjam')),
        );
        setState(() {
          isAvailable = false;
          isBorrowedByUser = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal meminjam buku')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan aksi dan tampilan tombol di bawah
    String buttonText = 'Loading...';
    VoidCallback? onPressed;
    Color buttonColor = Colors.grey;

    if (!isLoading) {
      if (isAvailable) {
        buttonText = 'Pinjam Buku';
        onPressed = _postLoan;
        buttonColor = Colors.green[700]!;
      } else if (isBorrowedByUser) {
        buttonText = 'Baca Sekarang';
        onPressed = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfScreen(
                bookUuid: _book!.uuid,
                pdfPath: _book!.filepdf,
                title: _book!.title,
              ),
            ),
          );
        };
        buttonColor = Colors.blue[700]!;
      } else {
        buttonText = 'Sedang Dipinjam';
        onPressed = null;
        buttonColor = Colors.grey[400]!;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background modern
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'Detail Buku',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      // --- STICKY BOTTOM BUTTON ---
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).padding.bottom > 0
                ? MediaQuery.of(context).padding.bottom
                : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            disabledBackgroundColor: Colors.grey[300],
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      // --- KONTEN HALAMAN ---
      body: isLoading || _book == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- AREA GAMBAR & JUDUL ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 24, bottom: 32),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Gambar Cover Buku
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _book!.image,
                              width: 160,
                              height: 230,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 160,
                                height: 230,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Judul Buku
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _book!.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Nama Penulis di bawah judul
                        Text(
                          _book!.author,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- AREA STATISTIK BUKU (Modern Card) ---
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            icon: Icons
                                .star_rounded, // Pakai ikon bintang atau halaman
                            label: 'Halaman',
                            value: _book!.pages.toString(),
                          ),
                          Container(
                              width: 1, height: 40, color: Colors.grey[200]),
                          _buildStatItem(
                            icon: Icons.check_circle_outline_rounded,
                            label: 'Status',
                            value: _book!.availability == '0'
                                ? 'Habis'
                                : '${_book!.availability} Tersedia',
                            valueColor: _book!.availability == '0'
                                ? Colors.red
                                : Colors.green[700],
                          ),
                          Container(
                              width: 1, height: 40, color: Colors.grey[200]),
                          _buildStatItem(
                            icon: Icons.remove_red_eye_rounded,
                            label: 'Pembaca',
                            value: _book!.loan_count,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- SINOPSIS & DETAIL INFO ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sinopsis',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _book!.description,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700],
                            height: 1.6, // Spasi antar baris agar enak dibaca
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Detail Buku',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Kotak Detail
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow('Penerbit', _book!.publisher),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(height: 1, thickness: 1),
                              ),
                              _buildDetailRow('ISBN', _book!.isbn),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(height: 1, thickness: 1),
                              ),
                              _buildDetailRow(
                                  'Tahun Rilis', _book!.year.toString()),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(height: 1, thickness: 1),
                              ),
                              _buildDetailRow(
                                  'Kategori', _book!.categories.join(', ')),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 32), // Spasi bawah agar tidak mentok
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget bantuan untuk membangun kotak statistik
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey[400], size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // Widget bantuan untuk membangun baris detail buku
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
