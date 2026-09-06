import 'package:flutter/material.dart';
import 'package:pustaka/data/models/users.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:shimmer/shimmer.dart';

class AccountDetail extends StatefulWidget {
  const AccountDetail({Key? key}) : super(key: key);

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  final AuthService _authService = AuthService();
  GetUser? _getUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() async {
    try {
      GetUser getUser = await _authService.getUser();
      if (mounted) {
        setState(() {
          _getUser = getUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat detail akun')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FA), // Background abu-abu muda ala UI modern
      appBar: AppBar(
        title: const Text(
          'Detail Akun',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- BAGIAN FOTO PROFIL ---
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.green[400]!, width: 2.5),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          _getUser?.avatar ?? '',
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 110,
                            height: 110,
                            color: Colors.grey[200],
                            child: Icon(Icons.person_rounded,
                                size: 50, color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getUser?.name ?? 'Pengguna',
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // --- BAGIAN KOTAK INFORMASI ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Informasi Pribadi',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.person_outline_rounded,
                            iconColor: Colors.blue[600]!,
                            label: 'Nama Lengkap',
                            value: _getUser?.name ?? '-',
                          ),
                          const Divider(
                              height: 1,
                              indent: 64,
                              endIndent: 20,
                              color: Colors.black12),
                          _buildDetailRow(
                            icon: Icons.email_outlined,
                            iconColor: Colors.orange[500]!,
                            label: 'Email',
                            value: _getUser?.email ??
                                '-', // Pastikan model GetUser punya properti email
                          ),
                          const Divider(
                              height: 1,
                              indent: 64,
                              endIndent: 20,
                              color: Colors.black12),
                          _buildDetailRow(
                            icon: Icons.badge_outlined,
                            iconColor: Colors.purple[500]!,
                            label: 'NISN / NIP',
                            value: _getUser?.nisn ??
                                '-', // Pastikan model GetUser punya properti nisn
                          ),
                          const Divider(
                              height: 1,
                              indent: 64,
                              endIndent: 20,
                              color: Colors.black12),
                          _buildDetailRow(
                            icon: Icons.school_outlined,
                            iconColor: Colors.green[600]!,
                            label: 'Kelas / Jabatan',
                            value: _getUser?.description ??
                                '-', // Ganti className sesuai nama properti di modelmu
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  // --- WIDGET BARIS DATA ---
  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Ikon dengan background bulat
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          // Teks Label & Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET SHIMMER LOADING ---
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child:
                const CircleAvatar(radius: 55, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: 150, height: 24, color: Colors.white),
          ),
          const SizedBox(height: 44),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
