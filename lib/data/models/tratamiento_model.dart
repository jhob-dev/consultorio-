import 'package:json_annotation/json_annotation.dart';
part 'tratamiento_model.g.dart';

@JsonSerializable()
class Tratamiento {
  final int? id;
  @JsonKey(name: 'paciente_id')
  final int pacienteId;
  @JsonKey(name: 'historia_id')
  final int? historiaId;
  final DateTime fecha;
  @JsonKey(name: 'actividad_clinica')
  final String actividadClinica;
  final double? presupuesto;
  @JsonKey(name: 'firma_conforme')
  final bool firmaConforme;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  Tratamiento({
    this.id,
    required this.pacienteId,
    this.historiaId,
    DateTime? fecha,
    required this.actividadClinica,
    this.presupuesto,
    this.firmaConforme = false,
    this.createdAt,
  }) : fecha = fecha ?? DateTime.now();

  factory Tratamiento.fromJson(Map<String, dynamic> json) => _$TratamientoFromJson(json);
  Map<String, dynamic> toJson() => _$TratamientoToJson(this);

  Tratamiento copyWith({
    int? id,
    int? pacienteId,
    int? historiaId,
    DateTime? fecha,
    String? actividadClinica,
    double? presupuesto,
    bool? firmaConforme,
    DateTime? createdAt,
  }) {
    return Tratamiento(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      historiaId: historiaId ?? this.historiaId,
      fecha: fecha ?? this.fecha,
      actividadClinica: actividadClinica ?? this.actividadClinica,
      presupuesto: presupuesto ?? this.presupuesto,
      firmaConforme: firmaConforme ?? this.firmaConforme,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}