import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cita_model.dart';
import '../providers/cita_provider.dart';

class CitaCard extends StatelessWidget {
  final Cita cita;
  const CitaCard({super.key, required this.cita});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: () async {
          if (cita.id == null) return;
          final shouldMark = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Marcar como atendida'),
              content: const Text('¿Deseas marcar esta cita como atendida?'),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Atendida')),
              ],
            ),
          );
          if (shouldMark == true) {
            final provider = Provider.of<CitaProvider>(context, listen: false);
            final success = await provider.actualizarEstado(cita.id!, 'atendida');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(success ? 'Cita marcada como atendida' : 'No se pudo actualizar la cita')),
            );
          }
        },
        leading: CircleAvatar(
          backgroundColor: cita.estado == 'confirmada' ? Colors.green : Colors.orange,
          child: Text(cita.fechaHora.day.toString()),
        ),
        title: Text('${cita.fechaHora.hour}:${cita.fechaHora.minute.toString().padLeft(2, '0')} - ${cita.pacienteNombre ?? 'Paciente desconocido'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cita.tratamiento ?? cita.motivo ?? 'Sin tratamiento'),
            const SizedBox(height: 4),
            Text('Estado: ${cita.estado}${cita.presupuesto != null ? ' · Presupuesto: ${cita.presupuesto}' : ''}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}