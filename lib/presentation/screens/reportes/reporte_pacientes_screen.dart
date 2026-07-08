import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/paciente_provider.dart';

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
              itemCount: pacientes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total de pacientes: ${pacientes.length}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                final paciente = pacientes[index - 1];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
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
}
