import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_cliente.dart';

class AuthProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Inicia sesión con la contraseña maestra.
  Future<bool> login(String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storage.write(key: 'auth_token', value: token);
        print('💾 Token guardado: $token'); // ← LOG TEMPORAL
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Error inesperado del servidor';
      }
    } on DioException catch (e) {
  // Depuración temporal
  print('<<<< DIO ERROR >>>>');
  print('Tipo: ${e.type}');
  print('Mensaje: ${e.message}');
  print('Error original: ${e.error}');
  print('Response: ${e.response?.data}');
  print('Status Code: ${e.response?.statusCode}');
  
  if (e.response?.statusCode == 401) {
    _error = 'Contraseña incorrecta';
  } else {
    final message = e.response?.data is Map
        ? e.response?.data['error'] ?? 'No se pudo conectar con la API'
        : 'No se pudo conectar con la API';
    _error = message;
  }
}

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Cierra sesión, elimina el token y actualiza el estado.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Intenta invalidar el token en el servidor
      await _apiClient.dio.post(ApiConstants.logout);
    } catch (e) {
      // Ignora errores, igual cerraremos sesión localmente
    }
    await _storage.delete(key: 'auth_token');
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }

  /// Verifica si hay un token almacenado y actualiza el estado.
  Future<bool> checkLoginStatus() async {
    final token = await _storage.read(key: 'auth_token');
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
    return _isLoggedIn;
  }

  /// Limpia el mensaje de error.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}