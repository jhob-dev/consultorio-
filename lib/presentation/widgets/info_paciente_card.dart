import 'package:flutter/material.dart';
import '../../data/models/paciente_model.dart';

class InfoPacienteCard extends StatelessWidget {
  final Paciente paciente;
  const InfoPacienteCard({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cédula: ${paciente.ci.isNotEmpty ? paciente.ci : 'N/A'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Fecha de Nacimiento: ${paciente.fechaNacimiento.millisecondsSinceEpoch > 1000 ? paciente.fechaNacimiento.toLocal().toString().split(' ')[0] : 'N/A'}'),
            Text('Género: ${paciente.genero.isNotEmpty ? paciente.genero : 'N/A'}'),
            Text('Teléfono: ${paciente.telefono ?? 'N/A'}'),
            Text('Ocupación: ${paciente.ocupacion ?? 'N/A'}'),
            Text('Estado Civil: ${paciente.estadoCivil ?? 'N/A'}'),
            Text('Dirección: ${paciente.direccion ?? 'N/A'}'),
            const Divider(),
            const Text('Familiar de contacto', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Parentesco: ${paciente.familiarParentesco ?? 'N/A'}'),
            Text('Nombre: ${paciente.familiarNombre ?? 'N/A'}'),
            Text('Cédula: ${paciente.familiarCi ?? 'N/A'}'),
            Text('Teléfono: ${paciente.familiarTelefono ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}