// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odontograma_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Odontograma _$OdontogramaFromJson(Map<String, dynamic> json) => Odontograma(
  id: (json['id'] as num?)?.toInt(),
  pacienteId: (json['paciente_id'] as num).toInt(),
  datosJson: json['datos_json'] as Map<String, dynamic>,
  observaciones: json['observaciones'] as String?,
  ultimaActualizacion: json['ultima_actualizacion'] == null
      ? null
      : DateTime.parse(json['ultima_actualizacion'] as String),
);

Map<String, dynamic> _$OdontogramaToJson(Odontograma instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paciente_id': instance.pacienteId,
      'datos_json': instance.datosJson,
      'observaciones': instance.observaciones,
      'ultima_actualizacion': instance.ultimaActualizacion?.toIso8601String(),
    };
