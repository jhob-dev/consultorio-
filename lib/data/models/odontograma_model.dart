import 'package:json_annotation/json_annotation.dart';
part 'odontograma_model.g.dart';

@JsonSerializable()
class Odontograma {
  final int? id;
  @JsonKey(name: 'paciente_id')
  final int pacienteId;
  @JsonKey(name: 'datos_json')
  final Map<String, dynamic> datosJson;
  final String? observaciones;
  @JsonKey(name: 'ultima_actualizacion')
  final DateTime? ultimaActualizacion;

  Odontograma({
    this.id,
    required this.pacienteId,
    required this.datosJson,
    this.observaciones,
    this.ultimaActualizacion,
  });

  factory Odontograma.fromJson(Map<String, dynamic> json) => _$OdontogramaFromJson(json);
  Map<String, dynamic> toJson() => _$OdontogramaToJson(this);
}