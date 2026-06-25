import 'package:flutter/material.dart';
import '../../data/models/paciente_model.dart';

class PacienteListTile extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback? onTap;
  const PacienteListTile({super.key, required this.paciente, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(paciente.nombresApellido),
      subtitle: Text('CI: ${paciente.ci}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}