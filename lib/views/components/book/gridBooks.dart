import 'package:flutter/material.dart';

Widget gridBooks(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: MediaQuery.of(context).size.width - 50,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width / 2 - 15,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://picsum.photos/200/320',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thinking, Fast and Slow',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'James Clear',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: 10, // Ganti jumlah item sesuai kebutuhan
          ),
        ),
      ],
    ),
  );
}
