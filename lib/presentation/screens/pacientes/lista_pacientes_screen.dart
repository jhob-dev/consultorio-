import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/paciente_provider.dart';
import '../../widgets/paciente_list_tile.dart';

class ListaPacientesScreen extends StatefulWidget {
  const ListaPacientesScreen({super.key});

  @override
  State<ListaPacientesScreen> createState() => _ListaPacientesScreenState();
}

class _ListaPacientesScreenState extends State<ListaPacientesScreen> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      _didLoad = true;
      final pacienteProvider = Provider.of<PacienteProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pacienteProvider.cargarPacientes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pacienteProvider = Provider.of<PacienteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Aquí puedes implementar la búsqueda de pacientes en el futuro
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda en desarrollo')),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context, pacienteProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pacientes/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PacienteProvider provider) {
    if (provider.isLoading && provider.pacientes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.cargarPacientes(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (provider.pacientes.isEmpty) {
      return const Center(
        child: Text('No hay pacientes registrados'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.cargarPacientes(),
      child: ListView.builder(
        itemCount: provider.pacientes.length,
        itemBuilder: (context, index) {
          final paciente = provider.pacientes[index];
          return PacienteListTile(
            paciente: paciente,
            onTap: paciente.id != null
                ? () => context.push('/pacientes/${paciente.id}')
                : null,
          );
        },
      ),
    );
  }
}