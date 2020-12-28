// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Error _$ErrorFromJson(Map<String, dynamic> json) {
  return Error(
    table: (json['errors'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as Map<String, dynamic>)?.map(
            (k, e) =>
                MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
          )),
    ),
  );
}

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
      'errors': instance.table,
    };
