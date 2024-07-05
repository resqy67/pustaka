import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://id3.labkom.us:4148/api'));
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  PostService() {
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

  Future<Map<String, dynamic>> loanStore(
      {required bookUuid, required userId}) async {
    try {
      final response = await _dio.post('/loan/store', data: {
        'book_uuid': bookUuid,
        'user_id': userId,
      });
      return response.data;
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('Failed to loan book');
    }
  }
}
