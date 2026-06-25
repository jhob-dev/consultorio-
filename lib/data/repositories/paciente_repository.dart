import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import 'package:consultorio/core/network/api_cliente.dart';
import '../models/paciente_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PacienteRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Paciente>> getPacientes({String? nombre, String? ci}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (nombre != null) queryParams['nombre'] = nombre;
      if (ci != null) queryParams['ci'] = ci;

      final response = await apiClient.dio.get(
        ApiConstants.pacientes,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );
      final data = response.data;
      if (data is List) {
        return data.map((json) => Paciente.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      if (data is Map<String, dynamic> && data['data'] is List) {
        return (data['data'] as List).map((json) => Paciente.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      throw 'Respuesta de pacientes inválida';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Future<Paciente> createPaciente(Paciente paciente) async {
  //   try {
  //     final response = await apiClient.dio.post(
  //       ApiConstants.pacientes,
  //       data: paciente.toJson(),
  //     );
  //     final id = response.data['id'];
  //     return paciente.copyWith(id: id);
  //   } on DioException catch (e) {
  //     throw _handleError(e);
  //   }
  // }
  Future<Paciente> createPaciente(Paciente paciente) async {
  final storage = const FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  try {
    final response = await apiClient.dio.post(
      ApiConstants.pacientes,
      data: paciente.toJson(),
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    final responseData = response.data;
    // Log for debugging: backend response when creating paciente
    try {
      debugPrint('createPaciente response: ${responseData.toString()}');
    } catch (_) {}
    if (responseData is Map<String, dynamic>) {
      return Paciente.fromJson(responseData);
    }
    if (responseData is Map) {
      return Paciente.fromJson(Map<String, dynamic>.from(responseData));
    }
    return paciente;
  } on DioException catch (e) {
    throw _handleError(e);
  }
}

  Future<Paciente> getPaciente(int id) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.paciente}/$id');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Paciente.fromJson(data);
      }
      if (data is Map) {
        return Paciente.fromJson(Map<String, dynamic>.from(data));
      }
      throw 'Respuesta de paciente inválida';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updatePaciente(int id, Paciente paciente) async {
    try {
      await apiClient.dio.put(
        '${ApiConstants.paciente}/$id',
        data: paciente.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePaciente(int id) async {
    try {
      await apiClient.dio.delete('${ApiConstants.paciente}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.statusCode == 409) {
      return 'Ya existe un paciente con esa cédula';
    }
    return e.response?.data['error'] ?? 'Error de conexión';
  }
}