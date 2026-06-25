import 'package:flutter/foundation.dart';
import '../../data/models/historia_clinica_model.dart';
import '../../data/repositories/historia_repository.dart';

class HistoriaProvider with ChangeNotifier {
  final _repo = HistoriaRepository();
  List<HistoriaClinica> _historias = [];
  HistoriaClinica? _historiaActual;
  bool _isLoading = false;
  String? _error;

  List<HistoriaClinica> get historias => _historias;
  HistoriaClinica? get historiaActual => _historiaActual;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarHistorias(int pacienteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _historias = await _repo.getHistorias(pacienteId: pacienteId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> crearHistoria(HistoriaClinica historia) async {
    _isLoading = true;
    notifyListeners();
    try {
      final nueva = await _repo.createHistoria(historia);
      _historias.insert(0, nueva);
      _historiaActual = nueva;
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