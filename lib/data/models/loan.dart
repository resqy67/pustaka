class Loan {
  // final String userId;
  final String loanDate;
  final String returnDate;
  final String bookTitle;
  final String bookImage;
  final String bookAuthor;
  final String bookUuid;

  Loan({
    // required this.userId,
    required this.loanDate,
    required this.returnDate,
    required this.bookTitle,
    required this.bookImage,
    required this.bookAuthor,
    required this.bookUuid,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      // userId: json['user_id'].toString(),
      loanDate: json['loan_date'].toString(),
      returnDate: json['return_date'].toString(),
      bookTitle: json['book']['title'].toString(),
      bookImage: json['book']['image'].toString(),
      bookAuthor: json['book']['author'].toString(),
      bookUuid: json['book']['uuid'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'user_id': userId,
      'loan_date': loanDate,
      'return_date': returnDate,
      'book_title': bookTitle,
      'book_image': bookImage,
      'book_author': bookAuthor,
      'book_uuid': bookUuid,
    };
  }
}

class LoanList {
  final List<Loan> loans;

  LoanList({
    required this.loans,
  });

  factory LoanList.fromJson(Map<String, dynamic> json) {
    // List<dynamic> loanJson = json['data']?['data'] ?? [];
    var loanJson = json['data'] as List<dynamic>;
    List<Loan> loan =
        loanJson.map((loanJson) => Loan.fromJson(loanJson)).toList();
    return LoanList(
      loans: loan,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loan': loans.map((loan) => loan.toJson()).toList(),
    };
  }
}
