class Paciente {
  final int? id;
  final String nombresApellido;
  final String ci;
  final DateTime fechaNacimiento;
  final int? edad;
  final String genero;
  final String? telefono;
  final String? ocupacion;
  final String? estadoCivil;
  final String? direccion;
  final String? familiarParentesco;
  final String? familiarNombre;
  final String? familiarCi;
  final String? familiarTelefono;
  final DateTime? createdAt;

  Paciente({
    this.id,
    required this.nombresApellido,
    required this.ci,
    required this.fechaNacimiento,
    this.edad,
    required this.genero,
    this.telefono,
    this.ocupacion,
    this.estadoCivil,
    this.direccion,
    this.familiarParentesco,
    this.familiarNombre,
    this.familiarCi,
    this.familiarTelefono,
    this.createdAt,
  });

   // Método copyWith para crear una copia modificada
  Paciente copyWith({
    int? id,
    String? nombresApellido,
    String? ci,
    DateTime? fechaNacimiento,
    String? genero,
    String? telefono,
    String? ocupacion,
    String? estadoCivil,
    String? direccion,
    String? familiarParentesco,
    String? familiarNombre,
    String? familiarCi,
    String? familiarTelefono,
    DateTime? createdAt,
  }) {
    return Paciente(
      id: id ?? this.id,
      nombresApellido: nombresApellido ?? this.nombresApellido,
      ci: ci ?? this.ci,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      genero: genero ?? this.genero,
      telefono: telefono ?? this.telefono,
      ocupacion: ocupacion ?? this.ocupacion,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      direccion: direccion ?? this.direccion,
      familiarParentesco: familiarParentesco ?? this.familiarParentesco,
      familiarNombre: familiarNombre ?? this.familiarNombre,
      familiarCi: familiarCi ?? this.familiarCi,
      familiarTelefono: familiarTelefono ?? this.familiarTelefono,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    if (json['data'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(json['data'] as Map<String, dynamic>);
    }
    if (json['paciente'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(json['paciente'] as Map<String, dynamic>);
    }
    return Map<String, dynamic>.from(json);
  }

  factory Paciente.fromJson(Map<String, dynamic> json) {
    final normalized = _normalizeJson(json);
    String parseString(dynamic value) => value?.toString() ?? '';
    int? parseInt(dynamic value) {
      if (value == null) return null;
      return int.tryParse(value.toString());
    }
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    final generoRaw = parseString(normalized['genero'] ?? normalized['sexo']);
    final telefonoRaw = parseString(normalized['telefono'] ?? normalized['telefono_movil'] ?? normalized['celular']);

    return Paciente(
      id: parseInt(normalized['id'] ?? normalized['paciente_id']),
      nombresApellido: parseString(normalized['nombres_apellido'] ?? normalized['nombre'] ?? normalized['nombre_completo'] ?? normalized['nombres']),
      ci: parseString(normalized['ci'] ?? normalized['cedula'] ?? normalized['cedula_paciente']),
      fechaNacimiento: parseDate(normalized['fecha_nacimiento'] ?? normalized['fecha'] ?? normalized['fechaNacimiento'] ?? normalized['fecha_de_nacimiento']),
      edad: parseInt(normalized['edad']),
      genero: generoRaw.isEmpty ? 'M' : generoRaw,
      telefono: telefonoRaw.isEmpty ? null : telefonoRaw,
      ocupacion: parseString(normalized['ocupacion']).isEmpty ? null : parseString(normalized['ocupacion']),
      estadoCivil: parseString(normalized['estado_civil'] ?? normalized['estadoCivil']).isEmpty ? null : parseString(normalized['estado_civil'] ?? normalized['estadoCivil']),
      direccion: parseString(normalized['direccion']).isEmpty ? null : parseString(normalized['direccion']),
      familiarParentesco: parseString(normalized['familiar_parentesco'] ?? normalized['familiarParentesco']).isEmpty ? null : parseString(normalized['familiar_parentesco'] ?? normalized['familiarParentesco']),
      familiarNombre: parseString(normalized['familiar_nombre'] ?? normalized['familiarNombre']).isEmpty ? null : parseString(normalized['familiar_nombre'] ?? normalized['familiarNombre']),
      familiarCi: parseString(normalized['familiar_ci'] ?? normalized['familiarCi']).isEmpty ? null : parseString(normalized['familiar_ci'] ?? normalized['familiarCi']),
      familiarTelefono: parseString(normalized['familiar_telefono'] ?? normalized['familiarTelefono']).isEmpty ? null : parseString(normalized['familiar_telefono'] ?? normalized['familiarTelefono']),
      createdAt: normalized['created_at'] != null ? parseDate(normalized['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombres_apellido': nombresApellido,
      'ci': ci,
      'fecha_nacimiento': fechaNacimiento.toIso8601String().split('T')[0],
      'genero': genero,
      'telefono': telefono,
      'ocupacion': ocupacion,
      'estado_civil': estadoCivil,
      'direccion': direccion,
      'familiar_parentesco': familiarParentesco,
      'familiar_nombre': familiarNombre,
      'familiar_ci': familiarCi,
      'familiar_telefono': familiarTelefono,
    };
  }


  
}