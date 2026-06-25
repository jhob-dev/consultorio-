import 'package:json_annotation/json_annotation.dart';
part 'habitos_model.g.dart';

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

  factory Habitos.fromJson(Map<String, dynamic> json) => _$HabitosFromJson(json);
  Map<String, dynamic> toJson() => _$HabitosToJson(this);
}