import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/data/models/loan.dart';
import 'package:pustaka/data/models/log_loan.dart';

class GetService {
// base url from labkom
  // final Dio _dio = Dio(BaseOptions(baseUrl: 'http://id3.labkom.us:4148/api'));

  // base url from vps
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://103.127.96.198:8000/api'));
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

  Future<BookList> books(String page) async {
    try {
      final response =
          await _dio.get('/books', queryParameters: {'page': page});
      // final data = response.data['data']['data'];
      // // print(data);
      return BookList.fromJson(response.data);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('failed to load books ss');
    }
  }

  Future<Book> book(String uuid) async {
    try {
      final response = await _dio.get('/book/$uuid');
      final data = response.data['data'];
      return Book.fromJson(data);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('failed to load book');
    }
  }

  Future<Map<String, dynamic>> checkAvailable(
      {required String bookUuid, required String userId}) async {
    try {
      final response = await _dio.get('/loan/check/$bookUuid/$userId');
      return response.data;
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('Failed to check availability');
    }
  }

  Future<LoanList> loan() async {
    try {
      final response = await _dio.get('/loan/user');
      final data = response.data['data'];
      print('ini data loan list $data');
      return LoanList.fromJson(data);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('failed to loan book ssssss');
    }
  }

  Future<LoanHistoryList> loanHistory() async {
    try {
      final response = await _dio.get('/loan-history/user');
      final data = response.data['data'];
      print('ini data loan history list $data');
      return LoanHistoryList.fromJson(data);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('failed to load loan history');
    }
  }
}
