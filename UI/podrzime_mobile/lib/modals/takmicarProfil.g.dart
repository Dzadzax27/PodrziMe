// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'takmicarProfil.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TakmicarProfil _$TakmicarProfilFromJson(Map<String, dynamic> json) =>
    TakmicarProfil(
      takmicarProfilId: (json['takmicarProfilId'] as num?)?.toInt(),
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      datumRodjenja: json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      kandidats: (json['kandidats'] as List<dynamic>?)
          ?.map((e) => Takmicar.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TakmicarProfilToJson(TakmicarProfil instance) =>
    <String, dynamic>{
      'takmicarProfilId': instance.takmicarProfilId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
      'kandidats': instance.kandidats,
    };
