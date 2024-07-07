import 'package:flutter/material.dart';
import 'package:pustaka/data/models/loan.dart';
import 'package:pustaka/views/components/book/index.dart';

Widget loanBooks(BuildContext context, LoanList? loanList) {
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
              Loan loan = loanList.loans[index];
              DateTime now = DateTime.now();
              DateTime returnDate = DateTime.parse(loan.returnDate);
              DateTime loanDate = DateTime.parse(loan.loanDate);
              int days = returnDate.difference(loanDate).inDays -
                  now.difference(loanDate).inDays;
              return Container(
                width: MediaQuery.of(context).size.width / 2 - 15,
                height: 300,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookPage(
                          bookUuid: loan.bookUuid,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                loan.bookImage,
                                // 'https://picsum.photos/200/320',
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 12, // Atur jarak dari atas
                                left: 8, // Atur jarak dari kiri
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$days Hari',
                                    // '7 Hari',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                                loan.bookTitle,
                                // 'Thinking, Fast and Slow',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                loan.bookAuthor,
                                // 'James Clear',
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
                  ),
                ),
              );
            },
            // childCount: 10, // Ganti jumlah item sesuai kebutuhan
            childCount: loanList!.loans.length,
          ),
        ),
      ],
    ),
  );
}
