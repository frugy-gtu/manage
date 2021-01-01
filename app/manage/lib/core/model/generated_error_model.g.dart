// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneratedErrorModel _$GeneratedErrorModelFromJson(Map<String, dynamic> json) {
  return GeneratedErrorModel(
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

Map<String, dynamic> _$GeneratedErrorModelToJson(
        GeneratedErrorModel instance) =>
    <String, dynamic>{
      'errors': instance.table,
    };
