import 'package:flutter/material.dart';
import 'package:pustaka/data/models/loan.dart';
import 'package:pustaka/views/components/book/index.dart';

Widget loanBooks(BuildContext context, LoanList? loanList) {
  // --- EMPTY STATE MODERN ---
  if (loanList == null || loanList.loans.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Belum ada buku yang dipinjam',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  return CustomScrollView(
    physics: const BouncingScrollPhysics(),
    slivers: <Widget>[
      SliverPadding(
        padding:
            const EdgeInsets.all(16.0), // Padding sejajar dengan layar lain
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.62, // Rasio otomatis yang presisi
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Loan loan = loanList.loans[index];

              DateTime now = DateTime.now();
              DateTime returnDate = DateTime.parse(loan.returnDate);

              // Rumus diperpendek, intinya: Tanggal Kembali dikurang Hari Ini
              int days = returnDate.difference(now).inDays;
              bool isWarning =
                  days <= 3; // Jika sisa 3 hari atau kurang, warnanya merah

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookPage(
                        bookUuid: loan.bookUuid,
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
                      // --- BAGIAN GAMBAR DAN BADGE ---
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                loan.bookImage,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.broken_image,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            // --- BADGE SISA HARI MODERN ---
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                // Logika warna: Merah jika < 3 hari, Hijau jika aman
                                decoration: BoxDecoration(
                                  color: isWarning
                                      ? Colors.redAccent
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      days < 0 ? 'Terlambat' : '$days Hari',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // --- BAGIAN TEKS INFORMASI BUKU ---
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loan.bookTitle,
                              maxLines:
                                  1, // Otomatis dipotong '...' oleh ellipsis
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
                              loan.bookAuthor,
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
            childCount: loanList.loans.length,
          ),
        ),
      ),
    ],
  );
}
