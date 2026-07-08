import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/paciente_provider.dart';
import '../../providers/cita_provider.dart';
import '../../providers/historia_provider.dart';
import '../../providers/tratamiento_provider.dart';

class ReportePacienteDetalleScreen extends StatefulWidget {
  final int pacienteId;
  const ReportePacienteDetalleScreen({super.key, required this.pacienteId});

  @override
  State<ReportePacienteDetalleScreen> createState() => _ReportePacienteDetalleScreenState();
}

class _ReportePacienteDetalleScreenState extends State<ReportePacienteDetalleScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pacienteProvider = Provider.of<PacienteProvider>(context, listen: false);
        final citaProvider = Provider.of<CitaProvider>(context, listen: false);
        final historiaProvider = Provider.of<HistoriaProvider>(context, listen: false);
        final tratamientoProvider = Provider.of<TratamientoProvider>(context, listen: false);

        pacienteProvider.cargarPaciente(widget.pacienteId);
        citaProvider.cargarCitas(pacienteId: widget.pacienteId);
        historiaProvider.cargarHistorias(widget.pacienteId);
        tratamientoProvider.cargarTratamientos(pacienteId: widget.pacienteId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de paciente')),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPacienteInfo(),
              const SizedBox(height: 16),
              _buildResumenSeccion(),
              const SizedBox(height: 16),
              _buildCitasSection(),
              const SizedBox(height: 16),
              _buildHistoriasSection(),
              const SizedBox(height: 16),
              _buildTratamientosSection(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Provider.of<PacienteProvider>(context, listen: false).cargarPaciente(widget.pacienteId);
    await Provider.of<CitaProvider>(context, listen: false).cargarCitas(pacienteId: widget.pacienteId);
    await Provider.of<HistoriaProvider>(context, listen: false).cargarHistorias(widget.pacienteId);
    await Provider.of<TratamientoProvider>(context, listen: false).cargarTratamientos(pacienteId: widget.pacienteId);
  }

  Widget _buildPacienteInfo() {
    return Consumer<PacienteProvider>(builder: (_, provider, __) {
      final paciente = provider.pacienteSeleccionado;
      if (provider.isLoading && paciente == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (paciente == null) {
        return const Text('No se encontró información del paciente.', style: TextStyle(color: Colors.red));
      }
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(paciente.nombresApellido, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('CI: ${paciente.ci}'),
              Text('Género: ${paciente.genero}'),
              Text('Nacimiento: ${paciente.fechaNacimiento.toLocal().toString().split(' ')[0]}'),
              if (paciente.telefono != null) Text('Teléfono: ${paciente.telefono}'),
              if (paciente.direccion != null) Text('Dirección: ${paciente.direccion}'),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildResumenSeccion() {
    return Consumer2<CitaProvider, HistoriaProvider>(
      builder: (_, citaProvider, historiaProvider, __) {
        final citas = citaProvider.citas;
        final historias = historiaProvider.historias;
        final atendidas = citas.where((c) => c.estado == 'atendida').length;
        final pendientes = citas.length - atendidas;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Resumen del paciente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Citas registradas: ${citas.length}'),
                Text('Citas atendidas: $atendidas'),
                Text('Citas pendientes: $pendientes'),
                Text('Historias clínicas registradas: ${historias.length}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCitasSection() {
    return Consumer<CitaProvider>(builder: (_, provider, __) {
      if (provider.isLoading && provider.citas.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final citas = provider.citas;
      return _buildSection(
        title: 'Citas del paciente',
        child: citas.isEmpty
            ? const Text('No hay citas registradas para este paciente.')
            : Column(
                children: citas.map((c) {
                  final fecha = c.fechaHora.toLocal();
                  final fechaTexto = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
                  final horaTexto = '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text('$fechaTexto $horaTexto'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Motivo: ${c.motivo ?? 'No especificado'}'),
                          Text('Estado: ${c.estado}'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      );
    });
  }

  Widget _buildHistoriasSection() {
    return Consumer<HistoriaProvider>(builder: (_, provider, __) {
      if (provider.isLoading && provider.historias.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final historias = provider.historias;
      return _buildSection(
        title: 'Historias clínicas',
        child: historias.isEmpty
            ? const Text('No hay historias clínicas registradas para este paciente.')
            : Column(
                children: historias.map((h) {
                  final fecha = h.fechaConsulta?.toLocal();
                  final fechaString = fecha != null ? '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}' : 'Fecha no disponible';
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(fechaString),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Motivo: ${h.motivoConsulta}'),
                          if (h.diagnosticos != null && h.diagnosticos!.isNotEmpty)
                            Text('Diagnósticos: ${h.diagnosticos!.map((d) => d.descripcion).join(', ')}'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      );
    });
  }

  Widget _buildTratamientosSection() {
    return Consumer<TratamientoProvider>(builder: (_, provider, __) {
      if (provider.isLoading && provider.tratamientos.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final tratamientos = provider.tratamientos;
      return _buildSection(
        title: 'Tratamientos realizados',
        child: tratamientos.isEmpty
            ? const Text('No hay tratamientos registrados para este paciente.')
            : Column(
                children: tratamientos.map((t) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(t.actividadClinica),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (t.presupuesto != null) Text('Presupuesto: ${t.presupuesto}'),
                          Text('Firma conforme: ${t.firmaConforme ? 'Sí' : 'No'}'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      );
    });
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
