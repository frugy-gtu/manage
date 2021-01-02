import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/error_model.dart';
import 'package:manage/core/model/generated_error_model.dart';
import 'package:manage/core/service/manage_response.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

String _baseUrl = 'http://ec2-52-15-131-192.us-east-2.compute.amazonaws.com';

class _NotImplementedRequestMethodException implements Exception {
  final dynamic message;
  _NotImplementedRequestMethodException([this.message]);
}

Future<ManageResponse> _makeRequest(
    {@required String url,
    @required RequestMethod method,
    dynamic data,
    Map<String, dynamic> queryParameters}) async {
  Options options = RequestOptions(
    headers: <String, dynamic>{'Authorization': 'Bearer ' + Auth.accessToken},
  );

  switch (method) {
    case RequestMethod.post:
      return ManageResponse(
          (await Dio().post(_baseUrl + url,
            data: data, queryParameters: queryParameters, options: options,)),
          null);
    case RequestMethod.get:
      return ManageResponse(
          (await Dio().get(_baseUrl + url,
              queryParameters: queryParameters, options: options)),
          null);
    case RequestMethod.put:
      return ManageResponse(
          (await Dio().put(_baseUrl + url,
              data: data, queryParameters: queryParameters, options: options)),
          null);
    default:
      throw _NotImplementedRequestMethodException();
  }
}

Future<ManageResponse> _handleRequest(
    {@required String url,
    @required RequestMethod method,
    dynamic data,
    Map<String, dynamic> queryParameters}) async {
  try {
    return await _makeRequest(
        url: url, method: method, data: data, queryParameters: queryParameters);
  } on DioError catch (e) {
    print(e);
    print(e.response.data);
    return ManageResponse(null, e.response);
  } on _NotImplementedRequestMethodException {
    rethrow;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<RequestResult> request<T>(
    {@required String url,
    @required RequestMethod method,
    dynamic jsonData,
    Map<String, dynamic> queryParameters,
    void Function(Response success) successCallback,
    void Function(Response failure) failureCallback,
    void Function(Response failure) unknownCallback,
    Function(dynamic) decode}) async {
  ManageResponse response = await _handleRequest(
      url: url, method: method, data: jsonData, queryParameters: queryParameters);

  if (response == null) {
    unknownCallback?.call(response.fail);
    return RequestResult(Status.fail, msg: 'Unknown error.');
  }

  if (response.success == null) {
    print('faillleeed');
    failureCallback?.call(response.fail);
    if (response.fail.statusCode == 400) {
      GeneratedErrorModel error =
          GeneratedErrorModel.fromJson(response.fail.data);
      String errorMsg = error?.table['schema_errors']?.values?.first[0];
      return RequestResult(Status.fail,
          msg: errorMsg ?? 'Something went wrong.');
    } else {
      String msg = ErrorModel.fromJson(response.fail.data).message;
      return RequestResult(Status.fail,
          msg: msg);
    }
  }

  successCallback?.call(response.success);
  if (response.success.data is List) {
    return RequestResult(Status.success,
        data: ((response.success.data as List)
            .map<T>((i) => decode?.call(i))
            .toList()));
  }

  return RequestResult(Status.success,
      msg: 'Success.', data: decode?.call(response.success.data));
}
