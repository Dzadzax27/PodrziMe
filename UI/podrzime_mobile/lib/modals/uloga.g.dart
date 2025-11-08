// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uloga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uloga _$UlogaFromJson(Map<String, dynamic> json) =>
    Uloga(nazivUloge: json['nazivUloge'] as String?)
      ..ulogaId = (json['ulogaId'] as num?)?.toInt();

Map<String, dynamic> _$UlogaToJson(Uloga instance) => <String, dynamic>{
  'ulogaId': instance.ulogaId,
  'nazivUloge': instance.nazivUloge,
};
