import 'package:flutter/material.dart';
import 'package:pustaka/views/widgets/account/accountDetail.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:pustaka/data/models/users.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pustaka/views/widgets/account/helpCenterScreen.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _authService = AuthService();
  GetUser? _getUser;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() async {
    try {
      GetUser getUser = await _authService.getUser();
      if (!mounted) return;
      setState(() {
        _getUser = getUser;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FA), // Latar belakang abu-abu terang modern
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              // --- SECTION: PROFILE HEADER ---
              _buildProfileHeader(),

              const SizedBox(height: 32),

              // --- SECTION: PENGATURAN AKUN ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pengaturan',
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

              // Kotak Menu (Dikelompokkan dalam satu kontainer putih)
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
                    _buildMenuTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Detail Akun',
                      subtitle: 'Kelola informasi pribadi kamu',
                      iconColor: Colors.blue[600]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountDetail()),
                        );
                      },
                    ),
                    // const Divider(
                    //     height: 1,
                    //     indent: 64,
                    //     endIndent: 20,
                    //     color: Colors.black12),
                    // _buildMenuTile(
                    //   icon: Icons.notifications_none_rounded,
                    //   title: 'Notifikasi',
                    //   subtitle: 'Atur pengingat pengembalian',
                    //   iconColor: Colors.orange[500]!,
                    //   onTap: () {
                    //     // Dummy onTap
                    //   },
                    // ),
                    const Divider(
                        height: 1,
                        indent: 64,
                        endIndent: 20,
                        color: Colors.black12),
                    _buildMenuTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat Bantuan',
                      subtitle: 'FAQ & Hubungi Pustakawan',
                      iconColor: Colors.green[600]!,
                      onTap: () {
                        // Dummy onTap
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpCenterScreen()));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- SECTION: LOGOUT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red[50], // Background merah sangat muda
                    foregroundColor: Colors.red[700], // Efek ripple warna merah
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    _showLogoutDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded,
                          color: Colors.red[700], size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Keluar Akun',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // KOMPONEN UI MODERN
  // =========================================================================

  Widget _buildProfileHeader() {
    if (_getUser == null) {
      return Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child:
                const CircleAvatar(radius: 50, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: 150, height: 24, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: 100, height: 16, color: Colors.white),
          ),
        ],
      );
    }

    return Column(
      children: [
        // Avatar dengan border dinamis
        Container(
          padding: const EdgeInsets.all(
              4), // Jarak antara foto dan garis border luar
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green[400]!, width: 2.5),
          ),
          child: ClipOval(
            child: Image.network(
              _getUser!.avatar,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: Icon(Icons.person_rounded,
                    size: 50, color: Colors.grey[400]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _getUser!.name,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getUser!.description,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded,
          size: 16, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  // --- POPUP KONFIRMASI LOGOUT ---
  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Keluar Akun?',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah kamu yakin ingin keluar dari aplikasi Pustaka?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // Tutup dialog
                        await _authService.logout();
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Ya, Keluar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
