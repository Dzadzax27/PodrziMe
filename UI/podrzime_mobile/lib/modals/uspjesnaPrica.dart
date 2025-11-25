import 'package:json_annotation/json_annotation.dart';
import 'dart:ffi';
part 'uspjesnaPrica.g.dart';

@JsonSerializable()
class UspjesnaPrica {
  int? uspjesnaPricaId;
  String naslovPrice;
  String prica;
  int? ukupnaDonacija;
  int? kandidatId;
  String? slika; // For byte arrays

  UspjesnaPrica({
    this.uspjesnaPricaId,
    required this.naslovPrice,
    required this.prica,
    this.ukupnaDonacija,
    this.kandidatId,
    this.slika,
  });

  // Factory for JSON deserialization
  factory UspjesnaPrica.fromJson(Map<String, dynamic> json) =>
      _$UspjesnaPricaFromJson(json);

  // JSON serialization using json_serializable
  Map<String, dynamic> toJson() => _$UspjesnaPricaToJson(this);

  @override
  String toString() {
    return 'UspjesnaPrica(naslov: $naslovPrice, donacija: $ukupnaDonacija, slika: $slika)';
  }
}
