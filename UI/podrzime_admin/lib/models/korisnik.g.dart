// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  email: json['email'] as String?,
  telefon: json['telefon'] as String?,
  korisnickoIme: json['korisnickoIme'] as String?,
  lozinka: json['lozinka'] as String?,
  lozinkaPotvrda: json['lozinkaPotvrda'] as String?,
  status: json['status'] as bool?,
  ulogaId: (json['ulogaId'] as num?)?.toInt(),
);

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
  'korisnikId': instance.korisnikId,
  'email': instance.email,
  'telefon': instance.telefon,
  'korisnickoIme': instance.korisnickoIme,
  'lozinka': instance.lozinka,
  'lozinkaPotvrda': instance.lozinkaPotvrda,
  'status': instance.status,
  'ulogaId': instance.ulogaId,
};
