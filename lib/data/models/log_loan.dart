class LoanHistory {
  // final String userId;
  final String loanDate;
  final String returnDate;
  final String bookTitle;
  final String bookImage;
  final String bookAuthor;
  final String bookUuid;

  LoanHistory({
    // required this.userId,
    required this.loanDate,
    required this.returnDate,
    required this.bookTitle,
    required this.bookImage,
    required this.bookAuthor,
    required this.bookUuid,
  });

  factory LoanHistory.fromJson(Map<String, dynamic> json) {
    return LoanHistory(
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

class LoanHistoryList {
  final List<LoanHistory> loanHistories;

  LoanHistoryList({
    required this.loanHistories,
  });

  factory LoanHistoryList.fromJson(Map<String, dynamic> json) {
    var loanJson = json['data'] as List<dynamic>;
    List<LoanHistory> loan =
        loanJson.map((loanJson) => LoanHistory.fromJson(loanJson)).toList();
    return LoanHistoryList(
      loanHistories: loan,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loan': loanHistories.map((loan) => loan.toJson()).toList(),
    };
  }
}
