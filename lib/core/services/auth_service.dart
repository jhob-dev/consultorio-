import 'package:consultorio/core/network/api_cliente.dart';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

import 'package:consultorio/core/services/token_storage.dart';
class AuthService {
  final ApiClient apiClient = ApiClient();
  final TokenStorage tokenStorage = TokenStorage();

  Future<bool> login(String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.login,
        data: {'password': password},
      );
      final token = response.data['token'];
      if (token != null) {
        await tokenStorage.saveToken(token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error de autenticación';
    }
  }

  Future<void> logout() async {
    try {
      await apiClient.dio.post(ApiConstants.logout);
    } catch (_) {}
    await tokenStorage.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    return await tokenStorage.hasToken();
  }
}