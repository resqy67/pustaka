import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                // margin: EdgeInsets.only(top: 20),
                child: Image.network(
                  'https://picsum.photos/200/320',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Thinking, Fast and Slow',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('James Clear',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      )),
                  Text(' | ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200,
                      )),
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                    weight: 20,
                  ),
                  Text('4.5',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        clipBehavior: Clip.antiAlias,
                        onPressed: () {},
                        child: Icon(Icons.access_time_filled_rounded),
                      ),
                      Text('Tersedia',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      ElevatedButton(
                        clipBehavior: Clip.antiAlias,
                        onPressed: () {},
                        child: Icon(Icons.my_library_books_outlined),
                      ),
                      Text('31 Pembaca',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec odio. Donec et nunc nec nisl ultricies ultricies. Donec auctor, nunc nec Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec odio. Nullam vel sapien sit amet',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 50),
                ),
                onPressed: () {},
                child: Text('Pinjam Buku')),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
