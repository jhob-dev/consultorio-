import 'package:flutter/material.dart';
import '../../data/models/historia_clinica_model.dart';

class HistoriaCard extends StatelessWidget {
  final HistoriaClinica historia;
  const HistoriaCard({super.key, required this.historia});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${historia.fechaConsulta?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Motivo: ${historia.motivoConsulta}'),
            if (historia.diagnosticos != null && historia.diagnosticos!.isNotEmpty) ...[
              const Divider(),
              const Text('Diagnósticos:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...historia.diagnosticos!.map((d) => Text('• ${d.descripcion}')),
            ],
          ],
        ),
      ),
    );
  }
}