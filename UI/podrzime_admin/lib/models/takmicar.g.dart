// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'takmicar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Takmicar _$TakmicarFromJson(Map<String, dynamic> json) =>
    Takmicar(
        kandidatId: (json['kandidatId'] as num?)?.toInt(),
        ime: json['ime'] as String?,
        prezime: json['prezime'] as String?,
        email: json['email'] as String?,
        datumRodjenja: json['datumRodjenja'] == null
            ? null
            : DateTime.parse(json['datumRodjenja'] as String),
        omeni: json['omeni'] as String?,
        uspjesi: json['uspjesi'] as String?,
        link: json['link'] as String?,
        brojTelefona: (json['brojTelefona'] as num?)?.toInt(),
        zeljenaDonacija: (json['zeljenaDonacija'] as num?)?.toInt(),
        kategorijaId: (json['kategorijaId'] as num?)?.toInt(),
        slika: json['slika'] as String?,
        odobren: json['odobren'] as bool?,
      )
      ..kategorija = json['kategorija'] == null
          ? null
          : Kategorija.fromJson(json['kategorija'] as Map<String, dynamic>);

Map<String, dynamic> _$TakmicarToJson(Takmicar instance) => <String, dynamic>{
  'kandidatId': instance.kandidatId,
  'ime': instance.ime,
  'prezime': instance.prezime,
  'email': instance.email,
  'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
  'omeni': instance.omeni,
  'uspjesi': instance.uspjesi,
  'link': instance.link,
  'brojTelefona': instance.brojTelefona,
  'zeljenaDonacija': instance.zeljenaDonacija,
  'kategorijaId': instance.kategorijaId,
  'slika': instance.slika,
  'odobren': instance.odobren,
  'kategorija': instance.kategorija,
};
