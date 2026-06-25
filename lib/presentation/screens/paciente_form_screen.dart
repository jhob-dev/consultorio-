import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/paciente_model.dart';
import '../providers/paciente_provider.dart';
import 'historia_form_screen.dart';

class PacienteFormScreen extends StatefulWidget {
  final Paciente? paciente;
  const PacienteFormScreen({super.key, this.paciente});

  @override
  State<PacienteFormScreen> createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _ciCtrl = TextEditingController();
  final _fechaNacCtrl = TextEditingController();
  String _genero = 'F';
  final _telCtrl = TextEditingController();
  final _ocupacionCtrl = TextEditingController();
  final _estadoCivilCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _famParentescoCtrl = TextEditingController();
  final _famNombreCtrl = TextEditingController();
  final _famCiCtrl = TextEditingController();
  final _famTelCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.paciente != null) {
      final p = widget.paciente!;
      _nombreCtrl.text = p.nombresApellido;
      _ciCtrl.text = p.ci;
        _fechaNacCtrl.text = (p.fechaNacimiento.millisecondsSinceEpoch > 1000)
          ? p.fechaNacimiento.toIso8601String().substring(0, 10)
          : '';
      _genero = p.genero;
      _telCtrl.text = p.telefono ?? '';
      _ocupacionCtrl.text = p.ocupacion ?? '';
      _estadoCivilCtrl.text = p.estadoCivil ?? '';
      _direccionCtrl.text = p.direccion ?? '';
      _famParentescoCtrl.text = p.familiarParentesco ?? '';
      _famNombreCtrl.text = p.familiarNombre ?? '';
      _famCiCtrl.text = p.familiarCi ?? '';
      _famTelCtrl.text = p.familiarTelefono ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PacienteProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.paciente == null ? 'Nuevo Paciente' : 'Editar Paciente')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre completo *'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _ciCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cédula *'),
              validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Requerido';
                    if (!RegExp(r'^\d+$').hasMatch(t)) return 'Solo números';
                return null;
              },
            ),
            TextFormField(
              controller: _fechaNacCtrl,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Fecha nacimiento (YYYY-MM-DD) *',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime initial = DateTime.now();
                    try {
                      if (_fechaNacCtrl.text.isNotEmpty) initial = DateTime.parse(_fechaNacCtrl.text);
                    } catch (_) {}
                    final picked = await showDatePicker(context: context, initialDate: initial, firstDate: DateTime(1900), lastDate: DateTime(2100));
                    if (picked != null) _fechaNacCtrl.text = picked.toIso8601String().split('T')[0];
                  },
                ),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Requerido';
                try {
                  final s = t.replaceAll(RegExp(r'[^0-9]'), '');
                  if (s.length != 8) return 'Formato YYYYMMDD o YYYY-MM-DD';
                  final y = int.parse(s.substring(0, 4));
                  final m = int.parse(s.substring(4, 6));
                  final d = int.parse(s.substring(6, 8));
                  DateTime(y, m, d);
                  return null;
                } catch (_) {
                  return 'Fecha inválida';
                }
              },
              onChanged: (v) {
                final formatted = _formatDateDigits(v);
                if (formatted != v) {
                  _fechaNacCtrl.value = TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
                }
              },
            ),
            DropdownButtonFormField<String>(
              value: _genero,
              items: const ['F', 'M', 'Otro'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _genero = v!),
              decoration: const InputDecoration(labelText: 'Género *'),
            ),
            TextFormField(controller: _telCtrl, decoration: const InputDecoration(labelText: 'Teléfono')),
            TextFormField(controller: _ocupacionCtrl, decoration: const InputDecoration(labelText: 'Ocupación')),
            TextFormField(controller: _estadoCivilCtrl, decoration: const InputDecoration(labelText: 'Estado civil')),
            TextFormField(controller: _direccionCtrl, decoration: const InputDecoration(labelText: 'Dirección')),
            const Divider(), const Text('Familiar de contacto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextFormField(controller: _famParentescoCtrl, decoration: const InputDecoration(labelText: 'Parentesco')),
            TextFormField(controller: _famNombreCtrl, decoration: const InputDecoration(labelText: 'Nombre familiar')),
            TextFormField(controller: _famCiCtrl, decoration: const InputDecoration(labelText: 'CI familiar')),
            TextFormField(controller: _famTelCtrl, decoration: const InputDecoration(labelText: 'Teléfono familiar')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: provider.isLoading ? null : () => _submit(context, provider),
              child: const Text('Guardar'),
            ),
            if (provider.error != null) Text(provider.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
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

  Future<void> _submit(BuildContext context, PacienteProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    final paciente = Paciente(
      id: widget.paciente?.id,
      nombresApellido: _nombreCtrl.text,
      ci: _ciCtrl.text,
      fechaNacimiento: DateTime.parse(_fechaNacCtrl.text),
      genero: _genero,
      telefono: _telCtrl.text.isEmpty ? null : _telCtrl.text,
      ocupacion: _ocupacionCtrl.text.isEmpty ? null : _ocupacionCtrl.text,
      estadoCivil: _estadoCivilCtrl.text.isEmpty ? null : _estadoCivilCtrl.text,
      direccion: _direccionCtrl.text.isEmpty ? null : _direccionCtrl.text,
      familiarParentesco: _famParentescoCtrl.text.isEmpty ? null : _famParentescoCtrl.text,
      familiarNombre: _famNombreCtrl.text.isEmpty ? null : _famNombreCtrl.text,
      familiarCi: _famCiCtrl.text.isEmpty ? null : _famCiCtrl.text,
      familiarTelefono: _famTelCtrl.text.isEmpty ? null : _famTelCtrl.text,
    );

    bool success;
    if (widget.paciente == null) {
      success = await provider.crearPaciente(paciente);
    } else {
      success = await provider.actualizarPaciente(widget.paciente!.id!, paciente);
    }

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.paciente == null
              ? 'Paciente creado con éxito'
              : 'Paciente actualizado con éxito'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      if (widget.paciente == null) {
        final id = provider.pacienteSeleccionado?.id;
        if (id != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HistoriaFormScreen(pacienteId: id)),
          );
        }
      } else {
        Navigator.pop(context);
      }
    } else {
      final message = provider.error ?? 'Ocurrió un error guardando el paciente';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
      );
    }
  }
}