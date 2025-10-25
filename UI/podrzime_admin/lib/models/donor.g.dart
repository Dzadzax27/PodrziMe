// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donor _$DonorFromJson(Map<String, dynamic> json) => Donor(
  donorId: (json['donorId'] as num?)?.toInt(),
  ime: json['ime'] as String?,
  prezime: json['prezime'] as String?,
  zanimanje: json['zanimanje'] as String?,
  ukupnoDonacija: (json['ukupnoDonacija'] as num?)?.toInt(),
  datumRodjenja: json['datumRodjenja'] == null
      ? null
      : DateTime.parse(json['datumRodjenja'] as String),
);

Map<String, dynamic> _$DonorToJson(Donor instance) => <String, dynamic>{
  'donorId': instance.donorId,
  'ime': instance.ime,
  'prezime': instance.prezime,
  'zanimanje': instance.zanimanje,
  'ukupnoDonacija': instance.ukupnoDonacija,
  'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
};
