// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostico_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Diagnostico _$DiagnosticoFromJson(Map<String, dynamic> json) => Diagnostico(
  id: (json['id'] as num?)?.toInt(),
  descripcion: json['descripcion'] as String,
  fechaDiagnostico: json['fecha_diagnostico'] == null
      ? null
      : DateTime.parse(json['fecha_diagnostico'] as String),
);

Map<String, dynamic> _$DiagnosticoToJson(Diagnostico instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descripcion': instance.descripcion,
      'fecha_diagnostico': instance.fechaDiagnostico?.toIso8601String(),
    };
