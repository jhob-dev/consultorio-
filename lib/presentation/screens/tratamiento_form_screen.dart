import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';
import '../../data/models/paciente_model.dart';
import '../../data/models/tratamiento_model.dart';
import '../providers/tratamiento_provider.dart';
import 'package:go_router/go_router.dart';

class TratamientoFormScreen extends StatefulWidget {
  final int? pacienteId;
  const TratamientoFormScreen({super.key, this.pacienteId});

  @override
  State<TratamientoFormScreen> createState() => _TratamientoFormScreenState();
}

class _TratamientoFormScreenState extends State<TratamientoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteIdCtrl = TextEditingController();
  final _actividadCtrl = TextEditingController();
  final _presupuestoCtrl = TextEditingController();
  bool _firmaConforme = false;

  @override
  void initState() {
    super.initState();
    if (widget.pacienteId != null) {
      _pacienteIdCtrl.text = widget.pacienteId.toString();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pacienteProvider = Provider.of<PacienteProvider>(context, listen: false);
      if (pacienteProvider.pacientes.isEmpty) {
        pacienteProvider.cargarPacientes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TratamientoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Tratamiento')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Consumer<PacienteProvider>(builder: (context, pp, __) {
              return Autocomplete<Paciente>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return pp.pacientes;
                  }
                  return pp.pacientes.where((Paciente p) {
                    final q = textEditingValue.text.toLowerCase();
                    return p.nombresApellido.toLowerCase().contains(q) || (p.ci ?? '').toLowerCase().contains(q) || p.id.toString() == q;
                  }).toList();
                },
                displayStringForOption: (Paciente p) => '${p.nombresApellido} (${p.ci ?? ''})',
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  controller.text = _pacienteIdCtrl.text.isNotEmpty ? _pacienteIdCtrl.text : controller.text;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(labelText: 'Paciente (nombre o CI) *'),
                    validator: (v) => v!.isEmpty ? 'Requerido' : null,
                  );
                },
                onSelected: (Paciente selection) {
                  _pacienteIdCtrl.text = selection.id.toString();
                },
              );
            }),
            TextFormField(
              controller: _actividadCtrl,
              decoration: const InputDecoration(labelText: 'Actividad Clínica *'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _presupuestoCtrl,
              decoration: const InputDecoration(labelText: 'Presupuesto'),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: const Text('Firma conforme'),
              value: _firmaConforme,
              onChanged: (v) => setState(() => _firmaConforme = v ?? false),
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

  Future<void> _guardar(BuildContext context, TratamientoProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    final tratamiento = Tratamiento(
      pacienteId: int.parse(_pacienteIdCtrl.text),
      actividadClinica: _actividadCtrl.text,
      presupuesto: _presupuestoCtrl.text.isEmpty ? null : double.parse(_presupuestoCtrl.text),
      firmaConforme: _firmaConforme,
    );
    final success = await provider.crearTratamiento(tratamiento);
    if (success && mounted) context.pop();
  }
}