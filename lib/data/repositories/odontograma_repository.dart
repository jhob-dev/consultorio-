import 'package:consultorio/core/network/api_cliente.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/odontograma_model.dart';

class OdontogramaRepository {
  final ApiClient apiClient = ApiClient();

  Future<Odontograma?> getOdontograma(int pacienteId) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.odontogramas,
        queryParameters: {'paciente_id': pacienteId},
      );
      return Odontograma.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw e.response?.data['error'] ?? 'Error al obtener odontograma';
    }
  }

  Future<void> saveOdontograma(Odontograma odontograma) async {
    try {
      await apiClient.dio.post(
        ApiConstants.odontogramas,
        data: odontograma.toJson(),
      );
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al guardar';
    }
  }
}