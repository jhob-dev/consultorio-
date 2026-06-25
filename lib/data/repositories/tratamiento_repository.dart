import 'package:consultorio/core/network/api_cliente.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/tratamiento_model.dart';

class TratamientoRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Tratamiento>> getTratamientos({int? pacienteId}) async {
    try {
      final query = pacienteId != null ? {'paciente_id': pacienteId} : null;
      final response = await apiClient.dio.get(
        ApiConstants.tratamientos,
        queryParameters: query,
      );
      return (response.data as List).map((json) => Tratamiento.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Tratamiento> createTratamiento(Tratamiento tratamiento) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.tratamientos,
        data: tratamiento.toJson(),
      );
      return tratamiento.copyWith(id: response.data['id']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateTratamiento(int id, Map<String, dynamic> data) async {
    try {
      await apiClient.dio.put('${ApiConstants.tratamientos}/$id', data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTratamiento(int id) async {
    try {
      await apiClient.dio.delete('${ApiConstants.tratamientos}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    return e.response?.data['error'] ?? 'Error en la operación';
  }
}