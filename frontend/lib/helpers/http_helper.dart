import 'package:dio/dio.dart';

class HttpHelper {
  static final HttpHelper instance = HttpHelper._internal();
  static late Dio _dio;

  HttpHelper._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.0.105:8080',
    ));
  }

  Future<Response<T>> get<T>(String url) async {
    final response = await _dio.get<T>(url);
    return response;
  }

  Future<Response<T>> post<T>(String url, dynamic data) async {
    final response = await _dio.post<T>(
      url,
      data: data,
    );
    return response;
  }

  Future<Response> put<T>(String url, dynamic data) async {
    final response = await _dio.put<T>(
      url,
      data: data,
    );
    return response;
  }

  Future<Response> delete(String url , dynamic data) async {
    final response = await _dio.delete(url, data: data);
    return response;
  }
}
