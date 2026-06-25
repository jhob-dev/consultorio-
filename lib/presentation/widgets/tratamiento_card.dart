import 'package:flutter/material.dart';
import '../../data/models/tratamiento_model.dart';

class TratamientoCard extends StatelessWidget {
  final Tratamiento tratamiento;
  const TratamientoCard({super.key, required this.tratamiento});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(tratamiento.actividadClinica),
        subtitle: Text('Fecha: ${tratamiento.fecha.toLocal().toString().split(' ')[0]}'),
        trailing: tratamiento.presupuesto != null ? Text('\$${tratamiento.presupuesto!.toStringAsFixed(2)}') : null,
      ),
    );
  }
}