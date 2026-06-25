import 'package:flutter/material.dart';
import '../../data/models/odontograma_model.dart';
import '../providers/odontograma_provider.dart';

class OdontogramaScreen extends StatelessWidget {
  final Odontograma? odontograma;
  final int pacienteId;
  const OdontogramaScreen({super.key, this.odontograma, required this.pacienteId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.brush, size: 64),
          const SizedBox(height: 16),
          Text(odontograma != null ? 'Odontograma disponible' : 'No hay odontograma registrado'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navegar a la edición del odontograma
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad en desarrollo')),
              );
            },
            child: const Text('Editar Odontograma'),
          ),
        ],
      ),
    );
  }
}