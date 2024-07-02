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
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      publisher: json['publisher'],
      isbn: json['isbn'],
      year: json['year'],
      pages: json['pages'],
      image: json['image'],
      filepdf: json['filepdf'],
      categories: json['categories'],
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
