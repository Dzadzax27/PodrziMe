import 'package:json_annotation/json_annotation.dart';
import 'dart:ffi';
part 'uspjesnaPrica.g.dart';

@JsonSerializable()
class UspjesnaPrica {
  String naslovPrice;
  String prica;
  int? ukupnaDonacija;
  int? kandidatId;
  String? slika; // For byte arrays

  UspjesnaPrica({
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
}
