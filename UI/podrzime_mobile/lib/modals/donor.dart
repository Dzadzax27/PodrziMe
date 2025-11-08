import 'package:json_annotation/json_annotation.dart';

part 'donor.g.dart';

@JsonSerializable()
class Donor {
  int? donorId;
  String ime;
  String prezime;
  String? zanimanje;
  int? ukupnoDonacija;
  int? korisnikId;

  @DateOnlyConverter()
  DateTime? datumRodjenja;

  Donor({
    required this.ime,
    required this.prezime,
    this.zanimanje,
    this.ukupnoDonacija,
    this.datumRodjenja,
    this.korisnikId,
    this.donorId,
  });

  factory Donor.fromJson(Map<String, dynamic> json) => _$DonorFromJson(json);

  Map<String, dynamic> toJson() => _$DonorToJson(this);
}

class DateOnlyConverter implements JsonConverter<DateTime?, String?> {
  const DateOnlyConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json);

  @override
  String? toJson(DateTime? object) =>
      object == null ? null : object.toIso8601String().split('T')[0];
}
