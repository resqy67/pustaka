class Book {
  final String uuid;
  final String title;
  final String description;
  final String author;
  final String publisher;
  final String isbn;
  final String year;
  final String pages;
  final String image;
  final String filepdf;
  final String categories;

  Book(
      {required this.uuid,
      required this.title,
      required this.description,
      required this.author,
      required this.publisher,
      required this.isbn,
      required this.year,
      required this.pages,
      required this.image,
      required this.filepdf,
      required this.categories});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      uuid: json['uuid'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      author: json['author'].toString(),
      publisher: json['publisher'].toString(),
      isbn: json['isbn'].toString(),
      year: json['year'].toString(),
      pages: json['pages'].toString(),
      image: json['image'].toString(),
      filepdf: json['filepdf'].toString(),
      categories: json['categories'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'description': description,
      'author': author,
      'publisher': publisher,
      'isbn': isbn,
      'year': year,
      'pages': pages,
      'image': image,
      'filepdf': filepdf,
      'categories': categories,
    };
  }
}

class BookList {
  final List<Book> books;

  BookList({required this.books});

  factory BookList.fromJson(Map<String, dynamic> json) {
    // Safely handle null: Check if 'data' or its nested 'data' is null before casting
    List<dynamic> booksJson = json['data']?['data'] ?? [];
    // Assuming you have a Book.fromJson method to parse individual books
    List<Book> books =
        booksJson.map((bookJson) => Book.fromJson(bookJson)).toList();
    return BookList(books: books);
  }

  Map<String, dynamic> toJson() {
    return {
      'books': books.map((book) => book.toJson()).toList(),
    };
  }
}
