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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E73BE), Color(0xFF4F9FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Opacity(
                      opacity: 0.16,
                      child: Icon(Icons.insert_drive_file, size: 160, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Reportes clínicos', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Descarga datos en Excel o Word para tu consultorio.', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
