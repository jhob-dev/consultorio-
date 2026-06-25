import 'package:consultorio/core/network/api_cliente.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/historia_clinica_model.dart';

class HistoriaRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<HistoriaClinica>> getHistorias({int? pacienteId}) async {
    try {
      final query = pacienteId != null ? {'paciente_id': pacienteId} : null;
      final response = await apiClient.dio.get(
        ApiConstants.historias,
        queryParameters: query,
      );
      return (response.data as List).map((json) => HistoriaClinica.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<HistoriaClinica> createHistoria(HistoriaClinica historia) async {
    try {
      final payload = {
        'paciente_id': historia.pacienteId,
        'motivo_consulta': historia.motivoConsulta,
        if (historia.fechaConsulta != null) 'fecha_consulta': historia.fechaConsulta!.toIso8601String(),
        if (historia.antecedentes != null) 'antecedentes': historia.antecedentes!.toJson(),
        if (historia.habitos != null) 'habitos': historia.habitos!.toJson(),
        if (historia.consentimiento != null) 'consentimiento': historia.consentimiento!.toJson(),
        if (historia.diagnosticos != null && historia.diagnosticos!.isNotEmpty)
          'diagnosticos': historia.diagnosticos!.map((d) => d.descripcion).toList(),
      };
      final response = await apiClient.dio.post(
        ApiConstants.historias,
        data: payload,
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final id = responseData['historia_id'] ?? responseData['id'];
        return historia.copyWith(
          id: id is int ? id : int.tryParse(id?.toString() ?? ''),
        );
      }
      return historia;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    return e.response?.data['error'] ?? 'Error al guardar historia';
  }
}