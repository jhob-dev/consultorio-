import 'package:flutter/foundation.dart';
import '../../data/models/odontograma_model.dart';
import '../../data/repositories/odontograma_repository.dart';

class OdontogramaProvider with ChangeNotifier {
  final _repo = OdontogramaRepository();
  Odontograma? _odontograma;
  bool _isLoading = false;
  String? _error;

  Odontograma? get odontograma => _odontograma;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarOdontograma(int pacienteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _odontograma = await _repo.getOdontograma(pacienteId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> guardarOdontograma(Odontograma odontograma) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.saveOdontograma(odontograma);
      _odontograma = odontograma;
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

  void clearError() { _error = null; notifyListeners(); }
}