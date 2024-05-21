import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
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
            Card(
              child: ListTile(
                title: Text('Account'),
                subtitle: Text('Manage your account'),
                leading: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.pushNamed(context, '/account');
                },
              ),
            ),
            SizedBox(height: 5),
            // Card(
            //   child: ListTile(
            //     title: Text('Settings'),
            //     subtitle: Text('Manage your settings'),
            //     leading: Icon(Icons.settings),
            //     onTap: () {
            //       Navigator.pushNamed(context, '/settings');
            //     },
            //   ),
            // ),
            Card(
              child: ListTile(
                title: Text('Logout'),
                subtitle: Text('Logout from your account'),
                leading: Icon(Icons.logout),
                onTap: () {
                  Navigator.pushNamed(context, '/logout');
                },
              ),
            ),
          ],
        )));
  }
}
