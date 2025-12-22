// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obavijest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Obavijest _$ObavijestFromJson(Map<String, dynamic> json) => Obavijest(
  id: (json['id'] as num?)?.toInt(),
  sadrzaj: json['sadrzaj'] as String?,
  datumKreiranja: _$JsonConverterFromJson<String, DateTime>(
    json['datumKreiranja'],
    const DateOnlyConverter().fromJson,
  ),
  kandidatId: (json['kandidatId'] as num?)?.toInt(),
  hasBeenSeen: json['hasBeenSeen'] as bool?,
);

Map<String, dynamic> _$ObavijestToJson(Obavijest instance) => <String, dynamic>{
  'id': instance.id,
  'sadrzaj': instance.sadrzaj,
  'hasBeenSeen': instance.hasBeenSeen,
  'datumKreiranja': _$JsonConverterToJson<String, DateTime>(
    instance.datumKreiranja,
    const DateOnlyConverter().toJson,
  ),
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
