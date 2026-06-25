// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cita_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cita _$CitaFromJson(Map<String, dynamic> json) => Cita(
  id: (json['id'] as num?)?.toInt(),
  pacienteId: (json['paciente_id'] as num).toInt(),
  fechaHora: DateTime.parse(json['fecha_hora'] as String),
  motivo: json['motivo'] as String?,
  estado: json['estado'] as String? ?? 'pendiente',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CitaToJson(Cita instance) => <String, dynamic>{
  'id': instance.id,
  'paciente_id': instance.pacienteId,
  'fecha_hora': instance.fechaHora.toIso8601String(),
  'motivo': instance.motivo,
  'estado': instance.estado,
  'created_at': instance.createdAt?.toIso8601String(),
};
