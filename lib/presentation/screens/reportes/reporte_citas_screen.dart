import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cita_provider.dart';
import '../../../data/models/cita_model.dart';

class ReporteCitasScreen extends StatefulWidget {
  const ReporteCitasScreen({super.key});

  @override
  State<ReporteCitasScreen> createState() => _ReporteCitasScreenState();
}

class _ReporteCitasScreenState extends State<ReporteCitasScreen> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CitaProvider>(context, listen: false).cargarCitas();
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      final fecha = picked.toIso8601String().split('T').first;
      await Provider.of<CitaProvider>(context, listen: false).cargarCitas(fecha: fecha);
    }
  }

  Future<void> _clearFilter() async {
    setState(() => _selectedDate = null);
    await Provider.of<CitaProvider>(context, listen: false).cargarCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de citas')),
      body: Consumer<CitaProvider>(builder: (context, provider, _) {
        if (provider.isLoading && provider.citas.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final citas = provider.citas;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtros de fecha', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: const Text('Seleccionar fecha'),
                        onPressed: _pickDate,
                      ),
                      if (_selectedDate != null)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.clear),
                          label: const Text('Limpiar'),
                          onPressed: _clearFilter,
                        ),
                    ],
                  ),
                  if (_selectedDate != null) ...[
                    const SizedBox(height: 8),
                    Text('Mostrando citas agendadas para: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                  ],
                ],
              ),
            ),
            Expanded(
              child: citas.isEmpty
                  ? const Center(child: Text('No hay citas registradas para este filtro'))
                  : ListView.builder(
                      itemCount: citas.length,
                      itemBuilder: (context, index) => _buildCitaTile(citas[index]),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCitaTile(Cita cita) {
    final fecha = cita.fechaHora.toLocal();
    final fechaTexto = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
    final horaTexto = '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(cita.pacienteNombre ?? 'Paciente sin nombre'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: $fechaTexto $horaTexto'),
            Text('Motivo: ${cita.motivo ?? 'No especificado'}'),
            Text('Estado: ${cita.estado}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
