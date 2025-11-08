// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kategorija _$KategorijaFromJson(Map<String, dynamic> json) =>
    Kategorija(kategorijaId: (json['kategorijaId'] as num?)?.toInt())
      ..nazivKategorije = json['nazivKategorije'] as String?
      ..podKategorijaId = (json['podKategorijaId'] as num?)?.toInt();

Map<String, dynamic> _$KategorijaToJson(Kategorija instance) =>
    <String, dynamic>{
      'kategorijaId': instance.kategorijaId,
      'nazivKategorije': instance.nazivKategorije,
      'podKategorijaId': instance.podKategorijaId,
    };
