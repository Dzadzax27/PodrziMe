// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donacija _$DonacijaFromJson(Map<String, dynamic> json) =>
    Donacija(donacijaId: (json['donacijaId'] as num?)?.toInt())
      ..datumDonacije = json['datumDonacije'] == null
          ? null
          : DateTime.parse(json['datumDonacije'] as String)
      ..iznosDonacije = (json['iznosDonacije'] as num?)?.toInt()
      ..donorId = (json['donorId'] as num?)?.toInt()
      ..cijena = (json['cijena'] as num?)?.toDouble();

Map<String, dynamic> _$DonacijaToJson(Donacija instance) => <String, dynamic>{
  'donacijaId': instance.donacijaId,
  'datumDonacije': instance.datumDonacije?.toIso8601String(),
  'iznosDonacije': instance.iznosDonacije,
  'donorId': instance.donorId,
  'cijena': instance.cijena,
};
