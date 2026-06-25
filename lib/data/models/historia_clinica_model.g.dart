// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historia_clinica_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoriaClinica _$HistoriaClinicaFromJson(Map<String, dynamic> json) =>
    HistoriaClinica(
      id: (json['id'] as num?)?.toInt(),
      pacienteId: (json['paciente_id'] as num).toInt(),
      motivoConsulta: json['motivo_consulta'] as String,
      fechaConsulta: json['fecha_consulta'] == null
          ? null
          : DateTime.parse(json['fecha_consulta'] as String),
      antecedentes: json['antecedentes'] == null
          ? null
          : Antecedentes.fromJson(json['antecedentes'] as Map<String, dynamic>),
      habitos: json['habitos'] == null
          ? null
          : Habitos.fromJson(json['habitos'] as Map<String, dynamic>),
      consentimiento: json['consentimiento'] == null
          ? null
          : Consentimiento.fromJson(
              json['consentimiento'] as Map<String, dynamic>,
            ),
      diagnosticos: (json['diagnosticos'] as List<dynamic>?)
          ?.map((e) => Diagnostico.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistoriaClinicaToJson(HistoriaClinica instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paciente_id': instance.pacienteId,
      'motivo_consulta': instance.motivoConsulta,
      'fecha_consulta': instance.fechaConsulta?.toIso8601String(),
      'antecedentes': instance.antecedentes,
      'habitos': instance.habitos,
      'consentimiento': instance.consentimiento,
      'diagnosticos': instance.diagnosticos,
    };

Antecedentes _$AntecedentesFromJson(Map<String, dynamic> json) => Antecedentes(
  diabetes: json['diabetes'] as bool?,
  alergias: json['alergias'] as bool?,
  drogas: json['drogas'] as bool?,
  cardiopatias: json['cardiopatias'] as bool?,
  ets: json['ets'] as bool?,
  anticonceptivos: json['anticonceptivos'] as bool?,
  sinusitis: json['sinusitis'] as bool?,
  neoplasicas: json['neoplasicas'] as bool?,
  embarazo: json['embarazo'] as bool?,
  asma: json['asma'] as bool?,
  digestivas: json['digestivas'] as bool?,
  covid19: json['covid19'] as bool?,
  eruptivas: json['eruptivas'] as bool?,
  quirurgicos: json['quirurgicos'] as bool?,
  fumador: json['fumador'] as String?,
  te: json['te'] as String?,
);

Map<String, dynamic> _$AntecedentesToJson(Antecedentes instance) =>
    <String, dynamic>{
      'diabetes': instance.diabetes,
      'alergias': instance.alergias,
      'drogas': instance.drogas,
      'cardiopatias': instance.cardiopatias,
      'ets': instance.ets,
      'anticonceptivos': instance.anticonceptivos,
      'sinusitis': instance.sinusitis,
      'neoplasicas': instance.neoplasicas,
      'embarazo': instance.embarazo,
      'asma': instance.asma,
      'digestivas': instance.digestivas,
      'covid19': instance.covid19,
      'eruptivas': instance.eruptivas,
      'quirurgicos': instance.quirurgicos,
      'fumador': instance.fumador,
      'te': instance.te,
    };

Habitos _$HabitosFromJson(Map<String, dynamic> json) => Habitos(
  onicofagia: json['onicofagia'] as bool?,
  queilofagia: json['queilofagia'] as bool?,
  succionDigital: json['succion_digital'] as bool?,
  bruxismo: json['bruxismo'] as bool?,
  desviacionAtm: json['desviacion_atm'] as bool?,
);

Map<String, dynamic> _$HabitosToJson(Habitos instance) => <String, dynamic>{
  'onicofagia': instance.onicofagia,
  'queilofagia': instance.queilofagia,
  'succion_digital': instance.succionDigital,
  'bruxismo': instance.bruxismo,
  'desviacion_atm': instance.desviacionAtm,
};

Consentimiento _$ConsentimientoFromJson(Map<String, dynamic> json) =>
    Consentimiento(
      acepta: json['acepta'] as bool,
      firmaDigital: json['firma_digital'] as String?,
    );

Map<String, dynamic> _$ConsentimientoToJson(Consentimiento instance) =>
    <String, dynamic>{
      'acepta': instance.acepta,
      'firma_digital': instance.firmaDigital,
    };
