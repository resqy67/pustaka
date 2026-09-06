import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pustaka/data/models/users.dart';

class AuthService {
  // base url from labkom
  // final Dio _dio = Dio(BaseOptions(baseUrl: 'http://id3.labkom.us:4148/api'));

  // base url from vps
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://pustaka.smkairlanggabpn.sch.id/api',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // bypass safeline web application firewall
        'user-agent': 'BypassPustaka/26',
      }));
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
    // final response = await _dio.post('/login', data: {
    //   'email': email,
    //   'password': password,
    // });
    // print('response data: ${response}');
    // final user = User.fromJson(response.data);
    // await _storage.write(key: 'token', value: user.token);
    // return user;
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      print('response data: ${response.data}');
      final user = User.fromJson(response.data);
      await _storage.write(key: 'token', value: user.token);
      return user;
    } on DioException catch (e) {
      // Di sini kita bisa lihat apa alasan server menolak (status 403)
      print('Error Status: ${e.response?.statusCode}');
      print('Error Response Data: ${e.response?.data}');
      rethrow;
    }
  }

  Future<void> logout() async {
    // final token = await _storage.read(key: ' token');
    // print(token);

    await _storage.delete(key: 'token');
  }

  Future<GetUser> getUser() async {
    final response = await _dio.get('/user');
    final data = response.data['data'];
    print('ini datanya $data');
    return GetUser.fromJson(data);
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'token');
    print(token);
    return token != null && token.isNotEmpty;
  }
}
