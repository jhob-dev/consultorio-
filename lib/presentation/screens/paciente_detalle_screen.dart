import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';
import '../providers/cita_provider.dart';
import '../providers/historia_provider.dart';
import '../providers/odontograma_provider.dart';
import '../widgets/info_paciente_card.dart';
import '../widgets/cita_card.dart';
import '../screens/paciente_form_screen.dart';
import 'package:go_router/go_router.dart';
import 'odontograma_screen.dart';

class PacienteDetalleScreen extends StatefulWidget {
  final int pacienteId;
  const PacienteDetalleScreen({super.key, required this.pacienteId});

  @override
  State<PacienteDetalleScreen> createState() => _PacienteDetalleScreenState();
}

class _PacienteDetalleScreenState extends State<PacienteDetalleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  Future<void> _cargarDatos() async {
    final pacienteProvider = context.read<PacienteProvider>();
    final citaProvider = context.read<CitaProvider>();
    final odontogramaProvider = context.read<OdontogramaProvider>();

    try {
      await Future.wait([
        pacienteProvider.cargarPaciente(widget.pacienteId),
        // cargar historias del paciente
        context.read<HistoriaProvider>().cargarHistorias(widget.pacienteId),
        citaProvider.cargarCitas(pacienteId: widget.pacienteId),
        odontogramaProvider.cargarOdontograma(widget.pacienteId),
      ]);
    } catch (e) {
      debugPrint('Error cargando datos del paciente: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<PacienteProvider>(
            builder: (_, provider, __) => Text(
              provider.pacienteSeleccionado?.nombresApellido ?? 'Paciente',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.insert_drive_file),
              tooltip: 'Reporte paciente',
              onPressed: () {
                context.push('/reportes/pacientes/${widget.pacienteId}');
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar paciente',
              onPressed: () {
                final paciente = context.read<PacienteProvider>().pacienteSeleccionado;
                if (paciente != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PacienteFormScreen(paciente: paciente)),
                  );
                }
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Info', icon: Icon(Icons.person)),
              Tab(text: 'Citas', icon: Icon(Icons.calendar_month)),
              Tab(text: 'Odontograma', icon: Icon(Icons.brush)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInfoTab(),
            _buildCitasTab(),
            _buildOdontogramaTab(),
          ],
        ),
        floatingActionButton: Builder(builder: (ctx) => _buildFAB(ctx) ?? const SizedBox.shrink()),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Consumer<PacienteProvider>(
      builder: (_, provider, __) {
        final paciente = provider.pacienteSeleccionado;
        if (paciente == null) {
          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoPacienteCard(paciente: paciente),
              const SizedBox(height: 12),
              Consumer<CitaProvider>(builder: (_, cp, __) {
                final citas = cp.citas.where((c) => c.pacienteId == paciente.id).toList();
                final pendientes = citas.where((c) => c.estado != 'atendida').length;
                final realizadas = citas.where((c) => c.estado == 'atendida').length;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Citas', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Pendientes: $pendientes'),
                          Text('Realizadas: $realizadas'),
                        ]),
                        ElevatedButton(onPressed: () => DefaultTabController.of(context).animateTo(1), child: const Text('Ver citas'))
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              _buildHistoriasList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoriasList() {
    return Consumer<HistoriaProvider>(builder: (_, provider, __) {
      if (provider.isLoading) return const SizedBox.shrink();
      if (provider.historias.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Historias clínicas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...provider.historias.map((h) => Card(
                  child: ListTile(
                    title: Text(h.motivoConsulta),
                    subtitle: Text(h.fechaConsulta != null ? h.fechaConsulta!.toLocal().toString().split(' ')[0] : 'Fecha no disponible'),
                    isThreeLine: h.diagnosticos != null && h.diagnosticos!.isNotEmpty,
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        // future: navegar a detalle de historia
                      },
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }

  Widget _buildCitasTab() {
    return Consumer<CitaProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading)
          return const Center(child: CircularProgressIndicator());
        final citas = provider.citas;
        final pendientes = citas.where((c) => c.estado != 'atendida').toList();
        final realizadas = citas.where((c) => c.estado == 'atendida').toList();
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text('Citas pendientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (pendientes.isEmpty) const Text('No hay citas pendientes'),
            ...pendientes.map((c) => CitaCard(cita: c)),
            const SizedBox(height: 12),
            const Text('Citas realizadas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (realizadas.isEmpty) const Text('No hay citas realizadas'),
            ...realizadas.map((c) => CitaCard(cita: c)),
          ],
        );
      },
    );
  }

  Widget _buildOdontogramaTab() {
    return Consumer<OdontogramaProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading)
          return const Center(child: CircularProgressIndicator());
        final odontograma = provider.odontograma;
        return OdontogramaScreen(
          odontograma: odontograma,
          pacienteId: widget.pacienteId,
        );
      },
    );
  }

  // Historias / Tratamientos / Diagnósticos se gestionan en el flujo inicial

  Widget? _buildFAB(BuildContext ctx) {
    final index = DefaultTabController.of(ctx).index;
    switch (index) {
      case 1:
        return FloatingActionButton(
          onPressed: () => ctx.push('/citas/nueva?paciente_id=${widget.pacienteId}'),
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
    // Nota: Historias, Diagnósticos y Tratamientos fueron integrados
    // en el flujo de creación de paciente → historia clínica → cita.
  }
}
