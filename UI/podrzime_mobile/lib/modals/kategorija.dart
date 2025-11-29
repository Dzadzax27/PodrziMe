import 'package:json_annotation/json_annotation.dart';

part 'kategorija.g.dart';

@JsonSerializable()
class Kategorija {
  int? kategorijaId;
  String? nazivKategorije;
  int? podKategorijaId;

  Kategorija({this.kategorijaId, this.nazivKategorije, this.podKategorijaId});

  factory Kategorija.fromJson(Map<String, dynamic> json) =>
      _$KategorijaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KategorijaToJson(this);
}
