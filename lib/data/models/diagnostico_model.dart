import 'package:json_annotation/json_annotation.dart';
part 'diagnostico_model.g.dart';

@JsonSerializable()
class Diagnostico {
  final int? id;
  final String descripcion;
  @JsonKey(name: 'fecha_diagnostico')
  final DateTime? fechaDiagnostico;

  Diagnostico({this.id, required this.descripcion, this.fechaDiagnostico});

  factory Diagnostico.fromJson(Map<String, dynamic> json) => _$DiagnosticoFromJson(json);
  Map<String, dynamic> toJson() => _$DiagnosticoToJson(this);
}