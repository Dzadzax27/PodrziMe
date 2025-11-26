import 'package:json_annotation/json_annotation.dart';

part 'obavijest.g.dart';

@JsonSerializable()
class Obavijest {
  int? id;
  String? sadrzaj;

  @DateOnlyConverter()
  DateTime? datumKreiranja;

  int? kandidatId;

  Obavijest({this.id, this.sadrzaj, this.datumKreiranja, this.kandidatId});

  factory Obavijest.fromJson(Map<String, dynamic> json) =>
      _$ObavijestFromJson(json);

  Map<String, dynamic> toJson() => _$ObavijestToJson(this);
}

class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String().split('T')[0];
}
