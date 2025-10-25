import 'package:json_annotation/json_annotation.dart';

part 'donor.g.dart';

@JsonSerializable()
class Donor {
  int? donorId;
  String? ime;
  String? prezime;
  String? zanimanje;
  int? ukupnoDonacija;
  DateTime? datumRodjenja;

  Donor({
    this.donorId,
    this.ime,
    this.prezime,
    this.zanimanje,
    this.ukupnoDonacija,
    this.datumRodjenja,
  });

  factory Donor.fromJson(Map<String, dynamic> json) => _$DonorFromJson(json);
  Map<String, dynamic> toJson() => _$DonorToJson(this);

  @override
  String toString() {
    return 'Donor('
        'id: $donorId, '
        'ime: $ime, '
        'prezime: $prezime, '
        'zanimanje: $zanimanje, '
        'ukupnoDonacija: $ukupnoDonacija, '
        'datumRodjenja: $datumRodjenja'
        ')';
  }
}
