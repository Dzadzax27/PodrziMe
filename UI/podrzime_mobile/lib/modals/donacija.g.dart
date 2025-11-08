// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donacija _$DonacijaFromJson(Map<String, dynamic> json) => Donacija(
  datumDonacije: _$JsonConverterFromJson<String, DateTime>(
    json['datumDonacije'],
    const DateOnlyConverter().fromJson,
  ),
  iznosDonacije: (json['iznosDonacije'] as num?)?.toInt(),
  donorId: (json['donorId'] as num?)?.toInt(),
  cijena: (json['cijena'] as num?)?.toDouble(),
  kandidatId: (json['kandidatId'] as num?)?.toInt(),
)..donacijaId = (json['donacijaId'] as num?)?.toInt();

Map<String, dynamic> _$DonacijaToJson(Donacija instance) => <String, dynamic>{
  'donacijaId': instance.donacijaId,
  'datumDonacije': _$JsonConverterToJson<String, DateTime>(
    instance.datumDonacije,
    const DateOnlyConverter().toJson,
  ),
  'iznosDonacije': instance.iznosDonacije,
  'donorId': instance.donorId,
  'cijena': instance.cijena,
  'kandidatId': instance.kandidatId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
