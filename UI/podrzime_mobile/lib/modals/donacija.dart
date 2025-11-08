import 'package:json_annotation/json_annotation.dart';

part 'donacija.g.dart';

@JsonSerializable()
class Donacija {
  int? donacijaId;

  @DateOnlyConverter()
  DateTime? datumDonacije;
  int? iznosDonacije;
  int? donorId;
  double? cijena;
  int? kandidatId;

  Donacija({
    this.datumDonacije,
    this.iznosDonacije,
    this.donorId,
    this.cijena,
    this.kandidatId,
  });

  factory Donacija.fromJson(Map<String, dynamic> json) =>
      _$DonacijaFromJson(json);

  Map<String, dynamic> toJson() => _$DonacijaToJson(this);
}

class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String().split('T')[0];
}
