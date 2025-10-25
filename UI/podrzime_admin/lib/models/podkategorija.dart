import 'package:json_annotation/json_annotation.dart';

part 'podkategorija.g.dart';

@JsonSerializable()
class Podkategorija {
  int? podkategorijaId;
  String? nazivPodKategorije;

  Podkategorija({this.podkategorijaId});

  factory Podkategorija.fromJson(Map<String, dynamic> json) =>
      _$PodkategorijaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PodkategorijaToJson(this);
}
