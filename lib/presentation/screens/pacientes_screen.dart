import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';
import '../widgets/paciente_list_tile.dart';
import 'paciente_form_screen.dart';
import 'paciente_detalle_screen.dart';
import 'package:go_router/go_router.dart';
import 'pacientes/detalle_paciente_screen.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: Consumer<PacienteProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.pacientes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.pacientes.isEmpty) {
            return const Center(child: Text('No hay pacientes registrados'));
          }
          return ListView.builder(
            itemCount: provider.pacientes.length,
            itemBuilder: (_, i) => PacienteListTile(
              paciente: provider.pacientes[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PacienteDetalleScreen(
                    pacienteId: provider.pacientes[i].id!,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pacientes/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
