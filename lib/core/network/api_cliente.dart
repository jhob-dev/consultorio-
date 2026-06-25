import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_interceptor.dart';
import 'package:consultorio/core/services/token_storage.dart';

// class ApiClient {
//   static final ApiClient _instance = ApiClient._internal();
//   factory ApiClient() => _instance;
//   ApiClient._internal();

//   late Dio dio;
//   final TokenStorage tokenStorage = TokenStorage();

//   void initialize() {
//     dio = Dio(BaseOptions(
//       baseUrl: ApiConstants.baseUrl,
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//     ));
//     dio.interceptors.add(AuthInterceptor(tokenStorage: tokenStorage));
//   }
// }

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(AuthInterceptor());
    // Aquí puedes agregar interceptores para logging o para inyectar el token automáticamente
  }

  void initialize() {
    // Si necesitas cargar algo asíncrono al inicio
  }
}
