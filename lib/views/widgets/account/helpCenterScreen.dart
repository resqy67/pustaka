import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'Bagaimana cara meminjam buku?',
      'answer': 'Pilih buku yang kamu inginkan di menu Dashboard atau Library, lalu klik tombol "Pinjam Buku" di bagian bawah. Buku akan otomatis masuk ke menu PinjamanKu.'
    },
    {
      'question': 'Berapa lama batas maksimal peminjaman?',
      'answer': 'Batas waktu maksimal untuk setiap buku adalah 7 hari. Kamu akan mendapat notifikasi saat waktu pinjam hampir habis.'
    },
    {
      'question': 'Apa yang terjadi jika saya terlambat mengembalikan?',
      'answer': 'Status buku di PinjamanKu akan berubah menjadi "Terlambat". Harap segera melapor ke pustakawan untuk mengembalikan akses bacaan.'
    },
    {
      'question': 'Apakah saya bisa membaca tanpa internet?',
      'answer': 'Saat ini aplikasi membutuhkan koneksi internet aktif untuk memuat gambar cover dan sinkronisasi PDF buku dari server.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          icon: const Icon(Icons.support_agent_rounded, color: Colors.white),
          label: const Text(
            'Hubungi Pustakawan',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            // Logika untuk membuka WhatsApp atau Email Admin
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pertanyaan Populer',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Loop data FAQ
            ...faqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Hilangkan garis bawaan
                  child: ExpansionTile(
                    iconColor: Colors.green[700],
                    collapsedIconColor: Colors.grey[400],
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq['answer']!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}