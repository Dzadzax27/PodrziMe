import 'package:json_annotation/json_annotation.dart';

part 'takmicar.g.dart';

@JsonSerializable()
class Takmicar {
  int? kandidatId;
  String? ime;
  String? prezime;
  String? email;
  DateTime? datumRodjenja;
  String? omeni;
  String? uspjesi;
  String? Link;
  int? brojTelefona;
  int? zeljenaDonacija;

  Takmicar({this.kandidatId, this.ime});

  factory Takmicar.fromJson(Map<String, dynamic> json) =>
      _$TakmicarFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TakmicarToJson(this);
}
