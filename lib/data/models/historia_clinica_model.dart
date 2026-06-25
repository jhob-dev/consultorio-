// import 'diagnostico_model.dart';

// class AntecedentesPersonales {
//   final bool diabetes;
//   final bool alergias;
//   final bool drogas;
//   final bool cardiopatias;
//   final bool ets;
//   final bool anticonceptivos;
//   final bool sinusitis;
//   final bool neoplasicas;
//   final bool embarazo;
//   final bool asma;
//   final bool digestivas;
//   final bool covid19;
//   final bool eruptivas;
//   final bool quirurgicos;
//   final String? fumador;
//   final String? te;

//   AntecedentesPersonales({
//     this.diabetes = false,
//     this.alergias = false,
//     this.drogas = false,
//     this.cardiopatias = false,
//     this.ets = false,
//     this.anticonceptivos = false,
//     this.sinusitis = false,
//     this.neoplasicas = false,
//     this.embarazo = false,
//     this.asma = false,
//     this.digestivas = false,
//     this.covid19 = false,
//     this.eruptivas = false,
//     this.quirurgicos = false,
//     this.fumador,
//     this.te,
//   });

//   factory AntecedentesPersonales.fromJson(Map<String, dynamic> json) {
//     return AntecedentesPersonales(
//       diabetes: json['diabetes'] == 1 || json['diabetes'] == true,
//       alergias: json['alergias'] == 1 || json['alergias'] == true,
//       // ... mapear los demás campos
//       fumador: json['fumador'],
//       te: json['te'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'diabetes': diabetes,
//       'alergias': alergias,
//       'drogas': drogas,
//       'cardiopatias': cardiopatias,
//       'ets': ets,
//       'anticonceptivos': anticonceptivos,
//       'sinusitis': sinusitis,
//       'neoplasicas': neoplasicas,
//       'embarazo': embarazo,
//       'asma': asma,
//       'digestivas': digestivas,
//       'covid19': covid19,
//       'eruptivas': eruptivas,
//       'quirurgicos': quirurgicos,
//       'fumador': fumador,
//       'te': te,
//     };
//   }
// }

// class HabitosParafuncionales {
//   final bool onicofagia;
//   final bool queilofagia;
//   final bool succionDigital;
//   final bool bruxismo;
//   final bool desviacionAtm;

//   HabitosParafuncionales({
//     this.onicofagia = false,
//     this.queilofagia = false,
//     this.succionDigital = false,
//     this.bruxismo = false,
//     this.desviacionAtm = false,
//   });

//   factory HabitosParafuncionales.fromJson(Map<String, dynamic> json) {
//     return HabitosParafuncionales(
//       onicofagia: json['onicofagia'] == 1 || json['onicofagia'] == true,
//       queilofagia: json['queilofagia'] == 1 || json['queilofagia'] == true,
//       succionDigital: json['succion_digital'] == 1 || json['succion_digital'] == true,
//       bruxismo: json['bruxismo'] == 1 || json['bruxismo'] == true,
//       desviacionAtm: json['desviacion_atm'] == 1 || json['desviacion_atm'] == true,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'onicofagia': onicofagia,
//       'queilofagia': queilofagia,
//       'succion_digital': succionDigital,
//       'bruxismo': bruxismo,
//       'desviacion_atm': desviacionAtm,
//     };
//   }
// }

// class Consentimiento {
//   final bool acepta;
//   final String? firmaDigital;

//   Consentimiento({required this.acepta, this.firmaDigital});

//   factory Consentimiento.fromJson(Map<String, dynamic> json) {
//     return Consentimiento(
//       acepta: json['acepta'] == 1 || json['acepta'] == true,
//       firmaDigital: json['firma_digital'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'acepta': acepta,
//       'firma_digital': firmaDigital,
//     };
//   }
// }

// class HistoriaClinica {
//   final int? id;
//   final int pacienteId;
//   final String motivoConsulta;
//   final DateTime? fechaConsulta;
//   final AntecedentesPersonales? antecedentes;
//   final HabitosParafuncionales? habitos;
//   final Consentimiento? consentimiento;
//   final List<Diagnostico> diagnosticos;
//   final DateTime? createdAt;

//   HistoriaClinica({
//     this.id,
//     required this.pacienteId,
//     required this.motivoConsulta,
//     this.fechaConsulta,
//     this.antecedentes,
//     this.habitos,
//     this.consentimiento,
//     this.diagnosticos = const [],
//     this.createdAt,
//   });

//   factory HistoriaClinica.fromJson(Map<String, dynamic> json) {
//     List<Diagnostico> diags = [];
//     if (json['diagnosticos'] != null) {
//       diags = (json['diagnosticos'] as List).map((d) => Diagnostico.fromJson(d)).toList();
//     }

//     return HistoriaClinica(
//       id: json['id'] != null ? int.parse(json['id'].toString()) : null,
//       pacienteId: int.parse(json['paciente_id'].toString()),
//       motivoConsulta: json['motivo_consulta'] ?? '',
//       fechaConsulta: json['fecha_consulta'] != null ? DateTime.parse(json['fecha_consulta']) : null,
//       antecedentes: json['diabetes'] != null ? AntecedentesPersonales.fromJson(json) : null,
//       habitos: json['onicofagia'] != null ? HabitosParafuncionales.fromJson(json) : null,
//       consentimiento: json['acepta'] != null ? Consentimiento.fromJson(json) : null,
//       diagnosticos: diags,
//       createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {
//       'paciente_id': pacienteId,
//       'motivo_consulta': motivoConsulta,
//     };
//     if (antecedentes != null) {
//       data['antecedentes'] = antecedentes!.toJson();
//     }
//     if (habitos != null) {
//       data['habitos'] = habitos!.toJson();
//     }
//     if (consentimiento != null) {
//       data['consentimiento'] = consentimiento!.toJson();
//     }
//     if (diagnosticos.isNotEmpty) {
//       data['diagnosticos'] = diagnosticos.map((d) => d.descripcion).toList();
//     }
//     return data;
//   }
// }

import 'package:json_annotation/json_annotation.dart';
import 'diagnostico_model.dart';
// import 'antecedentes_model.dart';
// import 'habitos_model.dart';
part 'historia_clinica_model.g.dart';

@JsonSerializable()
class HistoriaClinica {
  final int? id;
  @JsonKey(name: 'paciente_id')
  final int pacienteId;
  @JsonKey(name: 'motivo_consulta')
  final String motivoConsulta;
  @JsonKey(name: 'fecha_consulta')
  final DateTime? fechaConsulta;
  final Antecedentes? antecedentes;
  final Habitos? habitos;
  final Consentimiento? consentimiento;
  final List<Diagnostico>? diagnosticos;

  HistoriaClinica({
    this.id,
    required this.pacienteId,
    required this.motivoConsulta,
    this.fechaConsulta,
    this.antecedentes,
    this.habitos,
    this.consentimiento,
    this.diagnosticos,
  });

  factory HistoriaClinica.fromJson(Map<String, dynamic> json) =>
      _$HistoriaClinicaFromJson(json);
  Map<String, dynamic> toJson() => _$HistoriaClinicaToJson(this);

  // Dentro de la clase HistoriaClinica en historia_clinica_model.dart
  HistoriaClinica copyWith({
    int? id,
    int? pacienteId,
    String? motivoConsulta,
    DateTime? fechaConsulta,
    Antecedentes? antecedentes,
    Habitos? habitos,
    Consentimiento? consentimiento,
    List<Diagnostico>? diagnosticos,
  }) {
    return HistoriaClinica(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      motivoConsulta: motivoConsulta ?? this.motivoConsulta,
      fechaConsulta: fechaConsulta ?? this.fechaConsulta,
      antecedentes: antecedentes ?? this.antecedentes,
      habitos: habitos ?? this.habitos,
      consentimiento: consentimiento ?? this.consentimiento,
      diagnosticos: diagnosticos ?? this.diagnosticos,
    );
  }
}

@JsonSerializable()
class Antecedentes {
  final bool? diabetes;
  final bool? alergias;
  final bool? drogas;
  final bool? cardiopatias;
  final bool? ets;
  final bool? anticonceptivos;
  final bool? sinusitis;
  final bool? neoplasicas;
  final bool? embarazo;
  final bool? asma;
  final bool? digestivas;
  final bool? covid19;
  final bool? eruptivas;
  final bool? quirurgicos;
  final String? fumador;
  final String? te;

  Antecedentes({
    this.diabetes,
    this.alergias,
    this.drogas,
    this.cardiopatias,
    this.ets,
    this.anticonceptivos,
    this.sinusitis,
    this.neoplasicas,
    this.embarazo,
    this.asma,
    this.digestivas,
    this.covid19,
    this.eruptivas,
    this.quirurgicos,
    this.fumador,
    this.te,
  });

  factory Antecedentes.fromJson(Map<String, dynamic> json) =>
      _$AntecedentesFromJson(json);
  Map<String, dynamic> toJson() => _$AntecedentesToJson(this);
}

@JsonSerializable()
class Habitos {
  final bool? onicofagia;
  final bool? queilofagia;
  @JsonKey(name: 'succion_digital')
  final bool? succionDigital;
  final bool? bruxismo;
  @JsonKey(name: 'desviacion_atm')
  final bool? desviacionAtm;

  Habitos({
    this.onicofagia,
    this.queilofagia,
    this.succionDigital,
    this.bruxismo,
    this.desviacionAtm,
  });

  factory Habitos.fromJson(Map<String, dynamic> json) =>
      _$HabitosFromJson(json);
  Map<String, dynamic> toJson() => _$HabitosToJson(this);
}

@JsonSerializable()
class Consentimiento {
  final bool acepta;
  @JsonKey(name: 'firma_digital')
  final String? firmaDigital;

  Consentimiento({required this.acepta, this.firmaDigital});

  factory Consentimiento.fromJson(Map<String, dynamic> json) =>
      _$ConsentimientoFromJson(json);
  Map<String, dynamic> toJson() => _$ConsentimientoToJson(this);
}
