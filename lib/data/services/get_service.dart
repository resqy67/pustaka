import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pustaka/data/models/book.dart';

class GetService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://id3.labkom.us:4148/api'));
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  GetService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<BookList> books() async {
    try {
      final response = await _dio.get('/books');
      // final data = response.data['data']['data'];
      // // print(data);
      return BookList.fromJson(response.data);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('failed to load books ss');
    }
  }
}
