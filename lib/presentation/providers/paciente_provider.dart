import 'package:flutter/foundation.dart';
import '../../data/models/paciente_model.dart';
import '../../data/repositories/paciente_repository.dart';

class PacienteProvider with ChangeNotifier {
  final PacienteRepository _repository = PacienteRepository();
  List<Paciente> _pacientes = [];
  Paciente? _pacienteSeleccionado;
  bool _isLoading = false;
  String? _error;

  List<Paciente> get pacientes => _pacientes;
  Paciente? get pacienteSeleccionado => _pacienteSeleccionado;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Future<void> cargarPacientes({String? nombre, String? ci}) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     _pacientes = await _repository.getPacientes(nombre: nombre, ci: ci);
  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
  
  Future<void> cargarPacientes() async {
  _isLoading = true;
  _error = null;
  notifyListeners();
  try {
    _pacientes = await _repository.getPacientes();
  } catch (e) {
    _error = e.toString();
  }
  _isLoading = false;
  notifyListeners();
}

  Future<void> cargarPaciente(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pacienteSeleccionado = await _repository.getPaciente(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearPaciente(Paciente paciente) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final nuevo = await _repository.createPaciente(paciente);
    _pacientes.add(nuevo);
    _pacienteSeleccionado = nuevo;
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

  Future<bool> actualizarPaciente(int id, Paciente paciente) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updatePaciente(id, paciente);
      // Crear la versión actualizada del paciente
    final pacienteActualizado = paciente.copyWith(id: id);
      final index = _pacientes.indexWhere((p) => p.id == id);
      if (index != -1) {
        _pacientes[index] = pacienteActualizado;
      }
      if (_pacienteSeleccionado?.id == id) {
        _pacienteSeleccionado = pacienteActualizado;
      }
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

  Future<bool> eliminarPaciente(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deletePaciente(id);
      _pacientes.removeWhere((p) => p.id == id);
      if (_pacienteSeleccionado?.id == id) {
        _pacienteSeleccionado = null;
      }
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}