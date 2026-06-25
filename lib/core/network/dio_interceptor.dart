// import 'package:consultorio/core/services/token_storage.dart';
// import 'package:dio/dio.dart';
// // import 'token_storage.dart'; 


// class AuthInterceptor extends Interceptor {
//   final TokenStorage tokenStorage;

//   AuthInterceptor({required this.tokenStorage});

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final token = await tokenStorage.getToken();
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//     options.headers['Content-Type'] = 'application/json';
//     handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       // Token expirado o inválido -> redirigir al login
//       await tokenStorage.deleteToken();
//       // Aquí puedes navegar a la pantalla de login (usando un callback o GlobalKey)
//     }
//     handler.next(err);
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'auth_token');
    print('🔑 Interceptor – token recuperado: $token'); // ← LOG TEMPORAL
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}