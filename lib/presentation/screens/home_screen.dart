import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/cita_provider.dart';
import '../widgets/cita_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Consultorio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final provider = context.read<CitaProvider>();
          if (!provider.isLoading && provider.citas.isEmpty) {
            provider.cargarCitas();
          }
        });
        return Consumer<CitaProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.citas.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.citas.isEmpty) {
              return const Center(
                child: Text('No hay citas pendientes para hoy'),
              );
            }
            return ListView.builder(
              itemCount: provider.citas.length,
              itemBuilder: (_, i) => CitaCard(cita: provider.citas[i]),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/citas/nueva'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menú',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Pacientes'),
            onTap: () {
              Navigator.pop(context);
              context.push('/pacientes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Citas'),
            onTap: () {
              Navigator.pop(context);
              context.push('/citas'); // Asegúrate de tener esta ruta
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Tratamientos'),
            onTap: () {
              Navigator.pop(context);
              context.push('/tratamientos'); // Asegúrate de tener esta ruta
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart),
            title: const Text('Reportes'),
            onTap: () {
              Navigator.pop(context);
              context.push('/reportes');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    context.go('/login');
  }
}
