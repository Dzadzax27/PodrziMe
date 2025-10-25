// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uspjesnaPrica.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UspjesnaPrica _$UspjesnaPricaFromJson(Map<String, dynamic> json) =>
    UspjesnaPrica(
      naslovPrice: json['naslovPrice'] as String,
      prica: json['prica'] as String,
      ukupnaDonacija: (json['ukupnaDonacija'] as num?)?.toInt(),
      kandidatId: (json['kandidatId'] as num?)?.toInt(),
      slika: json['slika'] as String?,
    );

Map<String, dynamic> _$UspjesnaPricaToJson(UspjesnaPrica instance) =>
    <String, dynamic>{
      'naslovPrice': instance.naslovPrice,
      'prica': instance.prica,
      'ukupnaDonacija': instance.ukupnaDonacija,
      'kandidatId': instance.kandidatId,
      'slika': instance.slika,
    };
