import 'package:dio/dio.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/service/manage_response.dart';

String _baseUrl = 'http://ec2-52-15-131-192.us-east-2.compute.amazonaws.com';

Future<ManageResponse> post(String url,
    {Map<String, dynamic> data, Map<String, dynamic> queryParameters}) async {
  try {
    Response response = await Dio().post(
      _baseUrl + url,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer ' + Auth.accessToken
        },
      ),
    );

    return ManageResponse(response, null);
  } on DioError catch (e) {
    print(e);
    print(e.response.data);
    return ManageResponse(null, e.response);
  } catch (e) {
    print(e);
    return null;
  }
}
