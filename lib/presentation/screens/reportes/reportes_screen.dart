import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildReportTile(
            context,
            icon: Icons.people,
            title: 'Reporte general de pacientes',
            subtitle: 'Lista y resumen de todos los pacientes registrados',
            route: '/reportes/pacientes',
          ),
          _buildReportTile(
            context,
            icon: Icons.calendar_today,
            title: 'Reporte de citas',
            subtitle: 'Citas con fecha, paciente, motivo y estado',
            route: '/reportes/citas',
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'También puedes generar un reporte de un paciente en específico desde su ficha de paciente.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required String route}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => context.push(route),
      ),
    );
  }
}
