import 'package:flutter/foundation.dart';
import '../../data/models/cita_model.dart';
import '../../data/repositories/cita_repository.dart';

class CitaProvider with ChangeNotifier {
  final _repo = CitaRepository();
  List<Cita> _citas = [];
  bool _isLoading = false;
  String? _error;

  List<Cita> get citas => _citas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarCitas({int? pacienteId, String? fecha}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _citas = await _repo.getCitas(pacienteId: pacienteId, fecha: fecha);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crearCita(Cita cita) async {
    _isLoading = true;
    notifyListeners();
    try {
      final nueva = await _repo.createCita(cita);
      _citas.add(nueva);
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

  Future<bool> actualizarEstado(int id, String estado) async {
    try {
      await _repo.updateCita(id, {'estado': estado});
      final index = _citas.indexWhere((c) => c.id == id);
      if (index != -1) {
        // If the cita is marked as 'atendida' remove it from the visible list
        if (estado == 'atendida') {
          _citas.removeAt(index);
        } else {
          _citas[index] = _citas[index].copyWith(estado: estado);
        }
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarCita(int id) async {
    try {
      await _repo.deleteCita(id);
      _citas.removeWhere((c) => c.id == id);
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