import 'package:consultorio/data/models/diagnostico_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/historia_clinica_model.dart';
import '../providers/historia_provider.dart';

class HistoriaFormScreen extends StatefulWidget {
  final int pacienteId;
  const HistoriaFormScreen({super.key, required this.pacienteId});

  @override
  State<HistoriaFormScreen> createState() => _HistoriaFormScreenState();
}

class _HistoriaFormScreenState extends State<HistoriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motivoCtrl = TextEditingController();
  
  // Antecedentes
  bool _diabetes = false, _alergias = false, _drogas = false, _cardiopatias = false;
  bool _ets = false, _anticonceptivos = false, _sinusitis = false, _neoplasicas = false;
  bool _embarazo = false, _asma = false, _digestivas = false, _covid19 = false;
  bool _eruptivas = false, _quirurgicos = false;
  final _fumadorCtrl = TextEditingController();
  final _teCtrl = TextEditingController();

  // Hábitos
  bool _onicofagia = false, _queilofagia = false, _succionDigital = false;
  bool _bruxismo = false, _desviacionAtm = false;

  // Diagnósticos
  final List<TextEditingController> _diagnosticoCtrls = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HistoriaProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Historia Clínica')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _motivoCtrl,
              decoration: const InputDecoration(labelText: 'Motivo de consulta *'),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text('Antecedentes Personales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildCheckbox('Diabetes', _diabetes, (v) => setState(() => _diabetes = v!)),
            _buildCheckbox('Alergias', _alergias, (v) => setState(() => _alergias = v!)),
            _buildCheckbox('Drogas', _drogas, (v) => setState(() => _drogas = v!)),
            _buildCheckbox('Cardiopatías', _cardiopatias, (v) => setState(() => _cardiopatias = v!)),
            _buildCheckbox('ETS', _ets, (v) => setState(() => _ets = v!)),
            _buildCheckbox('Anticonceptivos', _anticonceptivos, (v) => setState(() => _anticonceptivos = v!)),
            _buildCheckbox('Sinusitis', _sinusitis, (v) => setState(() => _sinusitis = v!)),
            _buildCheckbox('Neoplásicas', _neoplasicas, (v) => setState(() => _neoplasicas = v!)),
            _buildCheckbox('Embarazo', _embarazo, (v) => setState(() => _embarazo = v!)),
            _buildCheckbox('Asma', _asma, (v) => setState(() => _asma = v!)),
            _buildCheckbox('Digestivas', _digestivas, (v) => setState(() => _digestivas = v!)),
            _buildCheckbox('COVID-19', _covid19, (v) => setState(() => _covid19 = v!)),
            _buildCheckbox('Eruptivas', _eruptivas, (v) => setState(() => _eruptivas = v!)),
            _buildCheckbox('Quirúrgicos', _quirurgicos, (v) => setState(() => _quirurgicos = v!)),
            TextFormField(controller: _fumadorCtrl, decoration: const InputDecoration(labelText: 'Fumador')),
            TextFormField(controller: _teCtrl, decoration: const InputDecoration(labelText: 'Té')),
            
            const Divider(), const Text('Hábitos Parafuncionales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildCheckbox('Onicofagia', _onicofagia, (v) => setState(() => _onicofagia = v!)),
            _buildCheckbox('Queilofagia', _queilofagia, (v) => setState(() => _queilofagia = v!)),
            _buildCheckbox('Succión digital', _succionDigital, (v) => setState(() => _succionDigital = v!)),
            _buildCheckbox('Bruxismo', _bruxismo, (v) => setState(() => _bruxismo = v!)),
            _buildCheckbox('Desviación ATM', _desviacionAtm, (v) => setState(() => _desviacionAtm = v!)),

            const Divider(), const Text('Diagnósticos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._diagnosticoCtrls.map((ctrl) => TextFormField(controller: ctrl, decoration: const InputDecoration(labelText: 'Descripción'))),
            ElevatedButton.icon(
              onPressed: _agregarDiagnostico,
              icon: const Icon(Icons.add),
              label: const Text('Agregar diagnóstico'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: provider.isLoading ? null : () => _guardar(context, provider),
              child: const Text('Guardar Historia'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(title: Text(label), value: value, onChanged: onChanged);
  }

  void _agregarDiagnostico() {
    setState(() {
      _diagnosticoCtrls.add(TextEditingController());
    });
  }

  Future<void> _guardar(BuildContext context, HistoriaProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    final diagnosticos = _diagnosticoCtrls.map((c) => c.text).where((t) => t.isNotEmpty).toList();
    final historia = HistoriaClinica(
      pacienteId: widget.pacienteId,
      motivoConsulta: _motivoCtrl.text,
      fechaConsulta: DateTime.now(),
      antecedentes: Antecedentes(
        diabetes: _diabetes, alergias: _alergias, drogas: _drogas, cardiopatias: _cardiopatias,
        ets: _ets, anticonceptivos: _anticonceptivos, sinusitis: _sinusitis, neoplasicas: _neoplasicas,
        embarazo: _embarazo, asma: _asma, digestivas: _digestivas, covid19: _covid19, eruptivas: _eruptivas,
        quirurgicos: _quirurgicos, fumador: _fumadorCtrl.text.isEmpty ? null : _fumadorCtrl.text,
        te: _teCtrl.text.isEmpty ? null : _teCtrl.text,
      ),
      habitos: Habitos(
        onicofagia: _onicofagia, queilofagia: _queilofagia, succionDigital: _succionDigital,
        bruxismo: _bruxismo, desviacionAtm: _desviacionAtm,
      ),
      consentimiento: Consentimiento(acepta: true, firmaDigital: null),
      diagnosticos: diagnosticos.map((d) => Diagnostico(descripcion: d)).toList(),
    );

    final success = await provider.crearHistoria(historia);
    if (!mounted) return;
      if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Historia clínica guardada con éxito'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      GoRouter.of(context).go('/citas/nueva?paciente_id=${widget.pacienteId}');
    } else {
      final error = provider.error ?? 'Error guardando la historia clínica';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
      );
    }
  }
}