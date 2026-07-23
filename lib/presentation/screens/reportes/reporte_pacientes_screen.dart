import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/paciente_provider.dart';
import 'report_export_service.dart';

class ReportePacientesScreen extends StatefulWidget {
  const ReportePacientesScreen({super.key});

  @override
  State<ReportePacientesScreen> createState() => _ReportePacientesScreenState();
}

class _ReportePacientesScreenState extends State<ReportePacientesScreen> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      _didLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<PacienteProvider>(context, listen: false).cargarPacientes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte general de pacientes')),
      body: Consumer<PacienteProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.pacientes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(provider.error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.cargarPacientes(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final pacientes = provider.pacientes;
          return RefreshIndicator(
            onRefresh: () => provider.cargarPacientes(),
            child: ListView.builder(
              itemCount: pacientes.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pacientes registrados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Total de pacientes: ${pacientes.length}', style: const TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.table_chart),
                                label: const Text('Exportar Excel'),
                                onPressed: pacientes.isEmpty ? null : () => _exportExcel(pacientes),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.description),
                                label: const Text('Exportar Word'),
                                onPressed: pacientes.isEmpty ? null : () => _exportWord(pacientes),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }
                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEDF4FF), Color(0xFFE5F1FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.people_alt, size: 64, color: Color(0xFF1E73BE)),
                      ),
                    ),
                  );
                }
                final paciente = pacientes[index - 2];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Color(0xFF1E73BE)),
                    title: Text(paciente.nombresApellido),
                    subtitle: Text('CI: ${paciente.ci} • Género: ${paciente.genero}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: paciente.id != null
                        ? () => context.push('/reportes/pacientes/${paciente.id}')
                        : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _exportExcel(List<dynamic> pacientes) async {
    try {
      final csv = StringBuffer();
      csv.writeln('Nombre,CI,Género');
      for (final paciente in pacientes) {
        csv.writeln(
          '${ReportExportService.escapeCsv(paciente.nombresApellido ?? '')},'
          '${ReportExportService.escapeCsv(paciente.ci ?? '')},'
          '${ReportExportService.escapeCsv(paciente.genero ?? '')}',
        );
      }
      final content = csv.toString();
      final file = await ReportExportService.createCsvFile('reporte_pacientes', content);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reporte guardado en: ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al exportar reporte: $e')),
      );
    }
  }

  Future<void> _exportWord(List<dynamic> pacientes) async {
    try {
      final buffer = StringBuffer();
      buffer.writeln('<div class="section"><h2>Resumen de pacientes</h2><table>');
      buffer.writeln('<tr><th>Nombre</th><th>CI</th><th>Género</th></tr>');
      for (final paciente in pacientes) {
        buffer.writeln('<tr><td>${paciente.nombresApellido ?? ''}</td><td>${paciente.ci ?? ''}</td><td>${paciente.genero ?? ''}</td></tr>');
      }
      buffer.writeln('</table></div>');
      final html = ReportExportService.buildWordHtml('Reporte general de pacientes', buffer.toString());
      final file = await ReportExportService.createWordFile('reporte_pacientes', html);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reporte guardado en: ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al exportar reporte: $e')),
      );
    }
  }
}
