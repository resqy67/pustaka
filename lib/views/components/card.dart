import 'package:flutter/material.dart';
import 'package:pustaka/views/components/book/index.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  final String year;
  final String imageUrl;
  final String bookUuid;

  const CardWidget({
    required this.title,
    required this.description,
    required this.author,
    required this.year,
    required this.imageUrl,
    required this.bookUuid,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookPage(bookUuid: bookUuid)),
        );
      },
      child: Container(
        child: Card(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              // Icon(
                              //   Icons.star,
                              //   color: Colors.orange,
                              //   size: 20,
                              // ),
                              Text(
                                // rating.toString(),
                                author,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(' | '),
                              Text(year,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   child: Image.network(imageUrl),
              // )
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle
                    // border: Border.all(
                    //   color: Colors.grey,
                    //   width: 1.0,
                    // ),
                    ),
                child: Image.network(imageUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
