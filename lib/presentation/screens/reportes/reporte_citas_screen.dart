import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cita_provider.dart';
import '../../../data/models/cita_model.dart';
import 'report_export_service.dart';

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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF4FF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.insert_drive_file, size: 40, color: Color(0xFF1E73BE)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Exporta tus reportes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Genera archivos en Microsoft Excel o Word para compartir alianzas y archivos clínicos.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.table_chart),
                      label: const Text('Exportar Excel'),
                      onPressed: provider.citas.isEmpty ? null : () => _exportExcel(provider.citas),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.description),
                      label: const Text('Exportar Word'),
                      onPressed: provider.citas.isEmpty ? null : () => _exportWord(provider.citas),
                    ),
                  ),
                ],
              ),
            ),
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

  Future<void> _exportExcel(List<Cita> citas) async {
    final csv = StringBuffer();
    csv.writeln('Paciente,Fecha,Hora,Motivo,Estado');
    for (final cita in citas) {
      final fecha = cita.fechaHora.toLocal();
      final fechaTexto = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
      final horaTexto = '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
      csv.writeln(
        '${ReportExportService.escapeCsv(cita.pacienteNombre ?? '')},'
        '${ReportExportService.escapeCsv(fechaTexto)},'
        '${ReportExportService.escapeCsv(horaTexto)},'
        '${ReportExportService.escapeCsv(cita.motivo ?? '')},'
        '${ReportExportService.escapeCsv(cita.estado)}',
      );
    }
    final file = await ReportExportService.createCsvFile('reporte_citas', csv.toString());
    await ReportExportService.shareFile(file, 'Reporte de citas');
  }

  Future<void> _exportWord(List<Cita> citas) async {
    final buffer = StringBuffer();
    buffer.writeln('<div class="section"><h2>Resumen de citas</h2><table>');
    buffer.writeln('<tr><th>Paciente</th><th>Fecha</th><th>Hora</th><th>Motivo</th><th>Estado</th></tr>');
    for (final cita in citas) {
      final fecha = cita.fechaHora.toLocal();
      final fechaTexto = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
      final horaTexto = '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
      buffer.writeln('<tr><td>${cita.pacienteNombre ?? ''}</td><td>$fechaTexto</td><td>$horaTexto</td><td>${cita.motivo ?? ''}</td><td>${cita.estado}</td></tr>');
    }
    buffer.writeln('</table></div>');
    final html = ReportExportService.buildWordHtml('Reporte de citas', buffer.toString());
    final file = await ReportExportService.createWordFile('reporte_citas', html);
    await ReportExportService.shareFile(file, 'Reporte de citas');
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
