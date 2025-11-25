// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uspjesnaPrica.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UspjesnaPrica _$UspjesnaPricaFromJson(Map<String, dynamic> json) =>
    UspjesnaPrica(
      uspjesnaPricaId: (json['uspjesnaPricaId'] as num?)?.toInt(),
      naslovPrice: json['naslovPrice'] as String,
      prica: json['prica'] as String,
      ukupnaDonacija: (json['ukupnaDonacija'] as num?)?.toInt(),
      kandidatId: (json['kandidatId'] as num?)?.toInt(),
      slika: json['slika'] as String?,
    );

Map<String, dynamic> _$UspjesnaPricaToJson(UspjesnaPrica instance) =>
    <String, dynamic>{
      'uspjesnaPricaId': instance.uspjesnaPricaId,
      'naslovPrice': instance.naslovPrice,
      'prica': instance.prica,
      'ukupnaDonacija': instance.ukupnaDonacija,
      'kandidatId': instance.kandidatId,
      'slika': instance.slika,
    };
