import 'package:json_annotation/json_annotation.dart';
part 'antecedentes_model.g.dart';

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

  factory Antecedentes.fromJson(Map<String, dynamic> json) => _$AntecedentesFromJson(json);
  Map<String, dynamic> toJson() => _$AntecedentesToJson(this);
}