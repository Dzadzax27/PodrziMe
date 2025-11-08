import 'package:json_annotation/json_annotation.dart';
import 'package:podrzime_mobile/modals/korisnik.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';

part 'takmicarProfil.g.dart';

@JsonSerializable()
class TakmicarProfil {
  int? takmicarProfilId;
  String? ime;
  String? prezime;
  DateTime? datumRodjenja;
  int? korisnikId;

  // Relations
  Korisnik? korisnik;
  List<Takmicar>? kandidats;

  TakmicarProfil({
    this.takmicarProfilId,
    this.ime,
    this.prezime,
    this.datumRodjenja,
    this.korisnikId,
    this.korisnik,
    this.kandidats,
  });

  factory TakmicarProfil.fromJson(Map<String, dynamic> json) =>
      _$TakmicarProfilFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TakmicarProfilToJson(this);

  @override
  String toString() {
    return 'Takmicar('
        'ime: $ime, '
        'prezime: $prezime, '
        'korisnikId: $korisnikId'
        ')';
  }
}
