import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:podrzime_mobile/modals/kategorija.dart';
import 'package:podrzime_mobile/modals/takmicarProfil.dart';

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
  String? link;
  int? brojTelefona;
  int? zeljenaDonacija;
  int? kategorijaId;
  String? slika;
  bool? odobren;
  Kategorija? kategorija;
  int? takmicarProfilId;
  TakmicarProfil? takmicarProfil;

  Takmicar({
    this.kandidatId,
    this.ime,
    this.prezime,
    this.email,
    this.takmicarProfil,
    this.datumRodjenja,
    this.omeni,
    this.uspjesi,
    this.link,
    this.brojTelefona,
    this.takmicarProfilId,
    this.zeljenaDonacija,
    this.kategorijaId,
    this.slika,
    this.odobren,
    this.kategorija,
  });

  factory Takmicar.fromJson(Map<String, dynamic> json) =>
      _$TakmicarFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TakmicarToJson(this);

  @override
  String toString() {
    return 'Takmicar('
        'id: $kandidatId, '
        'ime: $ime, '
        'prezime: $prezime, '
        'odobren: $odobren'
        'uspjesi: $uspjesi'
        'Link :$link'
        'brojTelefona: $brojTelefona'
        'zeljenaDonacija :$zeljenaDonacija'
        'email : $email'
        'takmicarProfilId: $takmicarProfilId'
        'kategorijaId: $kategorijaId'
        'Kategorija : $kategorija'
        ')';
  }
}
