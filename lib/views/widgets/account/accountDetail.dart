import 'package:flutter/material.dart';

class AccountDetail extends StatelessWidget {
  const AccountDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Details',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://picsum.photos/200/320'),
              ),
              SizedBox(height: 20),
              _buildDetailRow(
                context,
                icon: Icons.person,
                label: 'Nama Lengkap',
                value: '12 RPL 1',
              ),
              _buildDetailRow(
                context,
                icon: Icons.class_rounded,
                label: 'Kelas',
                value: '12 RPL 1',
              ),
              _buildDetailRow(
                context,
                icon: Icons.password_rounded,
                label: 'Password',
                value: '*********',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
            color: Colors.black54,
          ),
        ),
        trailing: Icon(Icons.edit, color: Colors.green[600]),
        onTap: () {
          // Handle edit action
        },
      ),
    );
  }
}
