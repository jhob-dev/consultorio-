import 'package:consultorio/core/network/api_cliente.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../models/cita_model.dart';

class CitaRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Cita>> getCitas({int? pacienteId, String? fecha}) async {
    try {
      final query = <String, dynamic>{};
      if (pacienteId != null) query['paciente_id'] = pacienteId;
      if (fecha != null) query['fecha'] = fecha;
      final response = await apiClient.dio.get(
        ApiConstants.citas,
        queryParameters: query.isEmpty ? null : query,
      );
      final data = response.data as List;
      return data.map((json) => Cita.parseJson(Map<String, dynamic>.from(json))).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cita> createCita(Cita cita) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.citas,
        data: cita.toJson(),
      );
        final responseData = response.data;
      try {
          debugPrint('createCita response: $responseData');
      } catch (_) {}
        if (responseData is Map) {
          return Cita.parseJson(Map<String, dynamic>.from(responseData));
      }
        if (responseData is String || responseData is int) {
          final idValue = responseData;
          return cita.copyWith(id: int.tryParse(idValue.toString()));
        }
        return cita;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateCita(int id, Map<String, dynamic> data) async {
    try {
      await apiClient.dio.put('${ApiConstants.citas}/$id', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteCita(int id) async {
    try {
      await apiClient.dio.delete('${ApiConstants.citas}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    return e.response?.data['error'] ?? 'Error en la operación';
  }
}