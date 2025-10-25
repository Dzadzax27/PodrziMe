// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podkategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Podkategorija _$PodkategorijaFromJson(Map<String, dynamic> json) =>
    Podkategorija(podkategorijaId: (json['podkategorijaId'] as num?)?.toInt())
      ..nazivPodKategorije = json['nazivPodKategorije'] as String?;

Map<String, dynamic> _$PodkategorijaToJson(Podkategorija instance) =>
    <String, dynamic>{
      'podkategorijaId': instance.podkategorijaId,
      'nazivPodKategorije': instance.nazivPodKategorije,
    };
