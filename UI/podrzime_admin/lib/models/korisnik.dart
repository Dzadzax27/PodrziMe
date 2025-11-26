import 'package:json_annotation/json_annotation.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikId;
  String? email;
  String? telefon;
  String? korisnickoIme;
  String? lozinka;
  String? lozinkaPotvrda;
  bool? status;
  int? ulogaId;

  Korisnik({
    this.korisnikId,
    this.email,
    this.telefon,
    this.korisnickoIme,
    this.lozinka,
    this.lozinkaPotvrda,
    this.status,
    this.ulogaId,
  });

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
