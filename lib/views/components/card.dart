import 'package:flutter/material.dart';

//buatkan card widget
class CardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Function() onTap;

  const CardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 110,
                        height: 170,
                        child: Row(
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned.fill(
                        top: 40,
                        left: 10,
                        right: 20,
                        bottom: 20,
                        child: Material(
                          child: InkWell(
                            onTap: onTap,
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
