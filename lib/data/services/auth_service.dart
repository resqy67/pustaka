import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/data/models/users.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://id3.labkom.us:4148/api'));
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthService() {
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

  Future<User> login(String email, String password) async {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    final user = User.fromJson(response.data);
    await _storage.write(key: 'token', value: user.token);

    return user;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Future<User> getUser() async {
    final response = await _dio.get('/user');
    return User.fromJson(response.data);
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: ' token');
    return token != null;
  }

  Future<Book> books() async {
    final response = await _dio.get('/books');
    return response.data;
  }
}
