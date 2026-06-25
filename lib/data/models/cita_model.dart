// class Cita {
//   final int? id;
//   final int pacienteId;
//   final String? nombresApellido;
//   final String? ci;
//   final DateTime fechaHora;
//   final String? motivo;
//   final String estado; // pendiente, confirmada, cancelada, completada
//   final DateTime? createdAt;

//   Cita({
//     this.id,
//     required this.pacienteId,
//     this.nombresApellido,
//     this.ci,
//     required this.fechaHora,
//     this.motivo,
//     this.estado = 'pendiente',
//     this.createdAt,
//   });

//   factory Cita.fromJson(Map<String, dynamic> json) {
//     return Cita(
//       id: json['id'] != null ? int.parse(json['id'].toString()) : null,
//       pacienteId: int.parse(json['paciente_id'].toString()),
//       nombresApellido: json['nombres_apellido'],
//       ci: json['ci'],
//       fechaHora: DateTime.parse(json['fecha_hora']),
//       motivo: json['motivo'],
//       estado: json['estado'] ?? 'pendiente',
//       createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null) 'id': id,
//       'paciente_id': pacienteId,
//       'fecha_hora': fechaHora.toIso8601String(),
//       'motivo': motivo,
//       'estado': estado,
//     };
//   }
// }

import 'package:json_annotation/json_annotation.dart';
part 'cita_model.g.dart';

@JsonSerializable()
class Cita {
  final int? id;
  @JsonKey(name: 'paciente_id')
  final int pacienteId;
  @JsonKey(name: 'fecha_hora')
  final DateTime fechaHora;
  final String? motivo;
  @JsonKey(ignore: true)
  final String? pacienteNombre;
  final String? tratamiento;
  final String? presupuesto;
  final String estado;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  Cita({
    this.id,
    required this.pacienteId,
    required this.fechaHora,
    this.motivo,
    this.pacienteNombre,
    this.tratamiento,
    this.presupuesto,
    this.estado = 'pendiente',
    this.createdAt,
  });

  factory Cita.fromJson(Map<String, dynamic> json) => _$CitaFromJson(json);
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      if (id != null) 'id': id,
      'paciente_id': pacienteId,
      'fecha_hora': fechaHora.toIso8601String(),
      if (motivo != null) 'motivo': motivo,
      if (tratamiento != null) 'tratamiento': tratamiento,
      if (presupuesto != null) 'presupuesto': presupuesto,
      'estado': estado,
    };
    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }
    return data;
  }

  Cita copyWith({
    int? id,
    int? pacienteId,
    DateTime? fechaHora,
    String? motivo,
    String? pacienteNombre,
    String? tratamiento,
    String? presupuesto,
    String? estado,
    DateTime? createdAt,
  }) {
    return Cita(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      fechaHora: fechaHora ?? this.fechaHora,
      motivo: motivo ?? this.motivo,
      pacienteNombre: pacienteNombre ?? this.pacienteNombre,
      tratamiento: tratamiento ?? this.tratamiento,
      presupuesto: presupuesto ?? this.presupuesto,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Robust JSON parser that tolerates numeric fields coming as strings.
  static Cita parseJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    String? parseString(dynamic v) => v == null ? null : v.toString();

    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    final id = parseInt(json['id'] ?? json['cita_id']);
    final pacienteId = parseInt(json['paciente_id'] ?? json['pacienteId']) ?? 0;
    final fecha = parseDate(json['fecha_hora'] ?? json['fechaHora'] ?? json['fecha']);
    // paciente nombre may come as nested object or direct field
    String? pacienteNombre;
    if (json['paciente'] is Map) {
      pacienteNombre = parseString((json['paciente'] as Map)['nombres_apellido'] ?? (json['paciente'] as Map)['nombre']);
    }
    pacienteNombre ??= parseString(json['nombres_apellido'] ?? json['paciente_nombre'] ?? json['nombre']);
    final tratamiento = parseString(json['tratamiento'] ?? json['procedimiento'] ?? json['servicio']);
    final presupuesto = parseString(json['presupuesto'] ?? json['costo'] ?? json['precio']);

    return Cita(
      id: id,
      pacienteId: pacienteId,
      fechaHora: fecha,
      motivo: parseString(json['motivo']),
      pacienteNombre: pacienteNombre,
      tratamiento: tratamiento,
      presupuesto: presupuesto,
      estado: parseString(json['estado']) ?? 'pendiente',
      createdAt: json['created_at'] != null ? parseDate(json['created_at']) : null,
    );
  }
}