import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';
import '../../data/models/cita_model.dart';
import '../../data/repositories/paciente_repository.dart';
import '../providers/cita_provider.dart';

class CitaFormScreen extends StatefulWidget {
  final int? pacienteId;
  const CitaFormScreen({super.key, this.pacienteId});

  @override
  State<CitaFormScreen> createState() => _CitaFormScreenState();
}

class _CitaFormScreenState extends State<CitaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _ciCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _horaCtrl = TextEditingController();
  final _motivoCtrl = TextEditingController();
  final _tratamientoCtrl = TextEditingController();
  final _presupuestoCtrl = TextEditingController();
  String _estado = 'pendiente';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ciCtrl.addListener(_onPacienteBusquedaChanged);
    _nombreCtrl.addListener(_onPacienteBusquedaChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.pacienteId != null) {
        try {
          final provider = Provider.of<PacienteProvider>(context, listen: false);
          if (provider.pacienteSeleccionado?.id == widget.pacienteId) {
            _ciCtrl.text = provider.pacienteSeleccionado?.ci ?? '';
            _nombreCtrl.text = provider.pacienteSeleccionado?.nombresApellido ?? '';
          } else {
            // fallback to repository
            final repo = PacienteRepository();
            final p = await repo.getPaciente(widget.pacienteId!);
            _ciCtrl.text = p.ci;
            _nombreCtrl.text = p.nombresApellido;
          }
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ciCtrl.removeListener(_onPacienteBusquedaChanged);
    _nombreCtrl.removeListener(_onPacienteBusquedaChanged);
    _ciCtrl.dispose();
    _nombreCtrl.dispose();
    _fechaCtrl.dispose();
    _horaCtrl.dispose();
    _motivoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CitaProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _ciCtrl,
              decoration: const InputDecoration(labelText: 'Cédula del paciente'),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del paciente'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa al menos cédula o nombre para buscar al paciente.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fechaCtrl,
              decoration: InputDecoration(
                labelText: 'Fecha (YYYY-MM-DD) *',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime initial = DateTime.now();
                    try {
                      if (_fechaCtrl.text.isNotEmpty) {
                        initial = DateTime.parse(_fechaCtrl.text);
                      }
                    } catch (_) {}
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      _fechaCtrl.text = picked.toIso8601String().split('T')[0];
                    }
                  },
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requerido';
                try {
                  final s = v.replaceAll(RegExp(r'[^0-9]'), '');
                  if (s.length != 8) return 'Formato YYYYMMDD o YYYY-MM-DD';
                  final y = int.parse(s.substring(0, 4));
                  final m = int.parse(s.substring(4, 6));
                  final d = int.parse(s.substring(6, 8));
                  DateTime(y, m, d);
                  return null;
                } catch (_) {
                  return 'Formato inválido';
                }
              },
              onChanged: (v) {
                final formatted = _formatDateDigits(v);
                if (formatted != v) {
                  _fechaCtrl.value = TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
                }
              },
            ),
            TextFormField(
              controller: _horaCtrl,
              decoration: InputDecoration(
                labelText: 'Hora (HH:MM) *',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    TimeOfDay? initial;
                    try {
                      final parts = _horaCtrl.text.split(':');
                      if (parts.length >= 2) {
                        initial = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                      }
                    } catch (_) {}
                    final picked = await showTimePicker(context: context, initialTime: initial ?? TimeOfDay.now());
                    if (picked != null) {
                      final hh = picked.hour.toString().padLeft(2, '0');
                      final mm = picked.minute.toString().padLeft(2, '0');
                      _horaCtrl.text = '$hh:$mm';
                    }
                  },
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requerido';
                final s = v.replaceAll(RegExp(r'[^0-9]'), '');
                if (s.length != 4) return 'Formato HHMM o HH:MM';
                final hh = int.parse(s.substring(0, 2));
                final mm = int.parse(s.substring(2, 4));
                if (hh < 0 || hh > 23 || mm < 0 || mm > 59) return 'Hora inválida';
                return null;
              },
              onChanged: (v) {
                final formatted = _formatTimeDigits(v);
                if (formatted != v) {
                  _horaCtrl.value = TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
                }
              },
            ),
            TextFormField(
              controller: _motivoCtrl,
              decoration: const InputDecoration(labelText: 'Motivo'),
            ),
            TextFormField(
              controller: _tratamientoCtrl,
              decoration: const InputDecoration(labelText: 'Tratamiento'),
            ),
            TextFormField(
              controller: _presupuestoCtrl,
              decoration: const InputDecoration(labelText: 'Presupuesto'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            DropdownButtonFormField<String>(
              value: _estado,
              items: ['pendiente', 'confirmada', 'cancelada', 'completada']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _estado = v!),
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: provider.isLoading ? null : () => _guardar(context, provider),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardar(BuildContext context, CitaProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    final pacienteId = await _resolverPacienteId(context);
    if (pacienteId == null) return;

    try {
      final fechaHora = DateTime.parse('${_fechaCtrl.text} ${_horaCtrl.text}:00');
      final cita = Cita(
        pacienteId: pacienteId,
        fechaHora: fechaHora,
        motivo: _motivoCtrl.text.isEmpty ? null : _motivoCtrl.text,
        tratamiento: _tratamientoCtrl.text.isEmpty ? null : _tratamientoCtrl.text,
        presupuesto: _presupuestoCtrl.text.isEmpty ? null : _presupuestoCtrl.text,
        estado: _estado,
      );
      final success = await provider.crearCita(cita);
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cita agendada exitosamente'),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        GoRouter.of(context).go('/citas');
      } else {
        _mostrarError(
          ScaffoldMessenger.of(context),
          provider.error ?? 'No se pudo agendar la cita',
        );
      }
    } catch (e) {
      _mostrarError(ScaffoldMessenger.of(context), 'Formato de fecha u hora inválido');
    }
  }

  Future<int?> _resolverPacienteId(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ci = _ciCtrl.text.trim();
    final nombre = _nombreCtrl.text.trim();
    if (ci.isEmpty && nombre.isEmpty) {
      _mostrarError(messenger, 'Debes ingresar cédula o nombre del paciente');
      return null;
    }
    if (widget.pacienteId != null && ci.isEmpty && nombre.isEmpty) {
      return widget.pacienteId;
    }

    final repo = PacienteRepository();
    try {
      final pacientes = await repo.getPacientes(
        nombre: nombre.isEmpty ? null : nombre,
        ci: ci.isEmpty ? null : ci,
      );
      if (pacientes.isEmpty) {
        _mostrarError(messenger, 'No se encontró ningún paciente con esos datos');
        return null;
      }
      if (pacientes.length > 1 && ci.isEmpty) {
        _mostrarError(messenger, 'Se encontraron varios pacientes. Intenta usar la cédula exacta.');
        return null;
      }
      if (ci.isNotEmpty) {
        final match = pacientes.firstWhere((p) => p.ci == ci, orElse: () => pacientes.first);
        if (match.id == null) {
          _mostrarError(messenger, 'Paciente encontrado sin ID válido');
          return null;
        }
        return match.id!;
      }
      return pacientes.first.id;
    } catch (e) {
      _mostrarError(messenger, 'Error buscando paciente: ${e.toString()}');
      return null;
    }
  }

  void _onPacienteBusquedaChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final ci = _ciCtrl.text.trim();
      final nombre = _nombreCtrl.text.trim();
      if (ci.isEmpty && nombre.isEmpty) return;

      final repo = PacienteRepository();
      try {
        final pacientes = await repo.getPacientes(
          nombre: nombre.isEmpty ? null : nombre,
          ci: ci.isEmpty ? null : ci,
        );
        if (pacientes.isEmpty) return;

        if (ci.isNotEmpty && nombre.isEmpty && pacientes.length == 1) {
          _nombreCtrl.text = pacientes.first.nombresApellido;
        } else if (nombre.isNotEmpty && ci.isEmpty) {
          if (pacientes.length == 1) {
            _ciCtrl.text = pacientes.first.ci;
          } else {
            final exact = pacientes.firstWhere(
              (p) => p.nombresApellido.toLowerCase() == nombre.toLowerCase(),
              orElse: () => pacientes.first,
            );
            if (exact.nombresApellido.toLowerCase() == nombre.toLowerCase()) {
              _ciCtrl.text = exact.ci;
            }
          }
        }
      } catch (_) {
        // Ignorar errores de autocompletado, el usuario puede seguir escribiendo.
      }
    });
  }

  void _mostrarError(ScaffoldMessengerState messenger, String mensaje) {
    messenger.showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red.shade700),
    );
  }

  String _formatDateDigits(String v) {
    final d = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length <= 4) return d;
    if (d.length <= 6) return '${d.substring(0, 4)}-${d.substring(4)}';
    final y = d.substring(0, 4);
    final m = d.substring(4, 6);
    final rest = d.substring(6, d.length > 8 ? 8 : d.length);
    if (rest.isEmpty) return '$y-$m';
    return '$y-$m-${rest}';
  }

  String _formatTimeDigits(String v) {
    final d = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length <= 2) return d;
    final h = d.substring(0, 2);
    final rest = d.substring(2, d.length > 4 ? 4 : d.length);
    if (rest.isEmpty) return h;
    return '$h:${rest}';
  }
}