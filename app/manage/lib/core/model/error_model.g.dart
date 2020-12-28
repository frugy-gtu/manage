// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) {
  return ErrorModel(
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

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'errors': instance.table,
    };
