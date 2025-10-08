import 'package:json_annotation/json_annotation.dart';

part 'donacija.g.dart';

@JsonSerializable()
class Donacija {
  int? donacijaId;
  DateTime? datumDonacije;
  int? iznosDonacije;
  int? donorId;
  double? cijena;

  Donacija({this.donacijaId});

  factory Donacija.fromJson(Map<String, dynamic> json) =>
      _$DonacijaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DonacijaToJson(this);
}
