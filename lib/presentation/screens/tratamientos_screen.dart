import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tratamiento_provider.dart';
import '../widgets/tratamiento_card.dart';
import 'package:go_router/go_router.dart';
class TratamientosScreen extends StatelessWidget {
  const TratamientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tratamientos')),
      body: Consumer<TratamientoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.tratamientos.isEmpty) return const Center(child: Text('No hay tratamientos'));
          return ListView.builder(
            itemCount: provider.tratamientos.length,
            itemBuilder: (_, i) => TratamientoCard(tratamiento: provider.tratamientos[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tratamientos/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}