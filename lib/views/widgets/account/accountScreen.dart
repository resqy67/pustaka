import 'package:flutter/material.dart';
import 'package:pustaka/views/widgets/account/accountDetail.dart';
import 'package:pustaka/data/services/auth_service.dart';

class AccountScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'User!',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://picsum.photos/200/320'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '35 / 60 Buku dibaca',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text('Akun'),
                  subtitle: Text('Kelola akun kamu'),
                  leading: Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AccountDetail();
                    }));
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text('Logout'),
                  subtitle: Text('Logout from your account'),
                  leading: Icon(Icons.logout),
                  onTap: () async {
                    await _authService.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ),
            ),
          ],
        )));
  }
}
