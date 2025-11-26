import 'package:json_annotation/json_annotation.dart';
import 'package:podrzime_admin/models/korisnik.dart';

part 'komentar.g.dart';

@JsonSerializable()
class Komentar {
  int? komentarId;
  String? komentar1;
  int? uspjesnaPricaId;
  int? korisnikId;
  Korisnik? korisnik;

  Komentar({
    this.komentarId,
    this.komentar1,
    this.uspjesnaPricaId,
    this.korisnikId,
    this.korisnik,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) =>
      _$KomentarFromJson(json);

  Map<String, dynamic> toJson() => _$KomentarToJson(this);

  @override
  String toString() {
    return 'Komentar(komentarId: $komentarId, komentar: $komentar1, uspjesnaPricaId: $uspjesnaPricaId, korisnikId: $korisnikId)';
  }
}
