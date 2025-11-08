// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donor _$DonorFromJson(Map<String, dynamic> json) => Donor(
  ime: json['ime'] as String,
  prezime: json['prezime'] as String,
  zanimanje: json['zanimanje'] as String?,
  ukupnoDonacija: (json['ukupnoDonacija'] as num?)?.toInt(),
  datumRodjenja: const DateOnlyConverter().fromJson(
    json['datumRodjenja'] as String?,
  ),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  donorId: (json['donorId'] as num?)?.toInt(),
);

Map<String, dynamic> _$DonorToJson(Donor instance) => <String, dynamic>{
  'donorId': instance.donorId,
  'ime': instance.ime,
  'prezime': instance.prezime,
  'zanimanje': instance.zanimanje,
  'ukupnoDonacija': instance.ukupnoDonacija,
  'korisnikId': instance.korisnikId,
  'datumRodjenja': const DateOnlyConverter().toJson(instance.datumRodjenja),
};
