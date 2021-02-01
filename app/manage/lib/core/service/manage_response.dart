import 'package:dio/dio.dart';

class ManageResponse {
  final Response success;
  final Response fail;
  const ManageResponse(this.success, this.fail);
}
