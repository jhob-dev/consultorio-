import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cita_provider.dart';
import '../widgets/cita_card.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CitaProvider>();
      if (!provider.isLoading) {
        provider.cargarCitas();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh citas whenever dependencies change (e.g., returning to this screen)
    // Use addPostFrameCallback to avoid calling notifyListeners() during the build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CitaProvider>();
      provider.cargarCitas();
    });
  }

  DateTime? _selectedDate;

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
      await context.read<CitaProvider>().cargarCitas(fecha: fecha);
    }
  }

  Future<void> _clearDateFilter() async {
    setState(() => _selectedDate = null);
    await context.read<CitaProvider>().cargarCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Citas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              context.push('/reportes/citas');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              await auth.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(leading: const Icon(Icons.people), title: const Text('Pacientes'), onTap: () { Navigator.pop(context); context.push('/pacientes'); }),
            ListTile(leading: const Icon(Icons.calendar_today), title: const Text('Citas'), onTap: () { Navigator.pop(context); context.push('/citas'); }),
            ListTile(leading: const Icon(Icons.medical_services), title: const Text('Tratamientos'), onTap: () { Navigator.pop(context); context.push('/tratamientos'); }),
            const Divider(),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Cerrar sesión'), onTap: () { Navigator.pop(context); context.go('/login'); }),
          ],
        ),
      ),
      body: Consumer<CitaProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.citas.isEmpty) return const Center(child: CircularProgressIndicator());
          final visibles = provider.citas.where((c) => c.estado != 'atendida').toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filtrar citas por fecha de agendado', style: TextStyle(fontWeight: FontWeight.bold)),
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
                            label: const Text('Limpiar filtro'),
                            onPressed: _clearDateFilter,
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
                child: visibles.isEmpty
                    ? const Center(child: Text('No hay citas'))
                    : ListView.builder(
                        itemCount: visibles.length,
                        itemBuilder: (_, i) => CitaCard(cita: visibles[i]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/citas/nueva'),
        child: const Icon(Icons.add),
      ),
    );
  }
}