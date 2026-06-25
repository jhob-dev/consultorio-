import 'package:flutter/foundation.dart';
import '../../data/models/tratamiento_model.dart';
import '../../data/repositories/tratamiento_repository.dart';

class TratamientoProvider with ChangeNotifier {
  final _repo = TratamientoRepository();
  List<Tratamiento> _tratamientos = [];
  bool _isLoading = false;
  String? _error;

  List<Tratamiento> get tratamientos => _tratamientos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarTratamientos({int? pacienteId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _tratamientos = await _repo.getTratamientos(pacienteId: pacienteId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crearTratamiento(Tratamiento tratamiento) async {
    _isLoading = true;
    notifyListeners();
    try {
      final nuevo = await _repo.createTratamiento(tratamiento);
      _tratamientos.add(nuevo);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarTratamiento(int id, Map<String, dynamic> data) async {
    try {
      await _repo.updateTratamiento(id, data);
      final index = _tratamientos.indexWhere((t) => t.id == id);
      if (index != -1) {
        final antiguo = _tratamientos[index];
        _tratamientos[index] = antiguo.copyWith(
          actividadClinica: data['actividad_clinica'] ?? antiguo.actividadClinica,
          presupuesto: data['presupuesto'] ?? antiguo.presupuesto,
          firmaConforme: data['firma_conforme'] ?? antiguo.firmaConforme,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarTratamiento(int id) async {
    try {
      await _repo.deleteTratamiento(id);
      _tratamientos.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() { _error = null; notifyListeners(); }
}