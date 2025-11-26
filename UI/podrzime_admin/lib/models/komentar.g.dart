// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentar _$KomentarFromJson(Map<String, dynamic> json) => Komentar(
  komentarId: (json['komentarId'] as num?)?.toInt(),
  komentar1: json['komentar1'] as String?,
  uspjesnaPricaId: (json['uspjesnaPricaId'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  korisnik: json['korisnik'] == null
      ? null
      : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
);

Map<String, dynamic> _$KomentarToJson(Komentar instance) => <String, dynamic>{
  'komentarId': instance.komentarId,
  'komentar1': instance.komentar1,
  'uspjesnaPricaId': instance.uspjesnaPricaId,
  'korisnikId': instance.korisnikId,
  'korisnik': instance.korisnik,
};
