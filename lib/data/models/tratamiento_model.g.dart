// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tratamiento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tratamiento _$TratamientoFromJson(Map<String, dynamic> json) => Tratamiento(
  id: (json['id'] as num?)?.toInt(),
  pacienteId: (json['paciente_id'] as num).toInt(),
  historiaId: (json['historia_id'] as num?)?.toInt(),
  fecha: json['fecha'] == null ? null : DateTime.parse(json['fecha'] as String),
  actividadClinica: json['actividad_clinica'] as String,
  presupuesto: (json['presupuesto'] as num?)?.toDouble(),
  firmaConforme: json['firma_conforme'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$TratamientoToJson(Tratamiento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paciente_id': instance.pacienteId,
      'historia_id': instance.historiaId,
      'fecha': instance.fecha.toIso8601String(),
      'actividad_clinica': instance.actividadClinica,
      'presupuesto': instance.presupuesto,
      'firma_conforme': instance.firmaConforme,
      'created_at': instance.createdAt?.toIso8601String(),
    };
