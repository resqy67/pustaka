import 'package:flutter/material.dart';
import 'package:pustaka/views/widgets/account/accountDetail.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:pustaka/data/models/users.dart';
import 'package:shimmer/shimmer.dart';

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
      setState(() {
        _getUser = getUser;
      });
      print('api dari account user: ${_getUser?.id}');
    } catch (e) {
      print('e $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            children: <Widget>[
              // if (_getUser != null)
              _getUser != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_getUser!.avatar),
                    )
                  : Shimmer.fromColors(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                      ),
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!),

              SizedBox(height: 20),
              // if (_getUser != null)
              _getUser != null
                  ? Text(
                      _getUser!.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  : Shimmer.fromColors(
                      child: Container(
                        width: 150,
                        height: 24,
                        color: Colors.grey[300],
                      ),
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!),
              SizedBox(height: 5),
              // if (_getUser != null)
              _getUser != null
                  ? Text(
                      _getUser!.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 150,
                        height: 24,
                        color: Colors.grey[100],
                      ),
                    ),
              SizedBox(height: 40),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    'Akun',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Kelola akun kamu'),
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blueAccent,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AccountDetail();
                    }));
                  },
                ),
              ),
              SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Logout from your account'),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await _authService.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
