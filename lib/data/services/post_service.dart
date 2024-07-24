import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostService {
// base url from labkom
  // final Dio _dio = Dio(BaseOptions(baseUrl: 'http://id3.labkom.us:4148/api'));

  // base url from indihome
  final Dio _dio = Dio(
      BaseOptions(baseUrl: 'http://851d07584dc9.sn.mynetname.net:8080/api'));
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

  // update tokenFcm in user
  Future<Map<String, dynamic>> updateTokenFcm() async {
    final tokenFcm = await _storage.read(key: 'tokenFcm');
    print('Token FCM: $tokenFcm');
    if (tokenFcm == null) {
      return {'message': 'Token FCM not found'};
    }
    try {
      final response = await _dio.post('/user/update-token-fcm', data: {
        'token_fcm': tokenFcm,
      });
      return response.data;
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('Failed to update token fcm');
    }
  }
}
