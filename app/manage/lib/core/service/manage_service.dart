import 'package:dio/dio.dart';
import 'package:manage/core/cache/auth.dart';

String _baseUrl = 'http://ec2-52-15-131-192.us-east-2.compute.amazonaws.com';

Future<Response> post(String url,
    {Map<String, dynamic> data, Map<String, dynamic> queryParameters}) async {
  try {
    return await Dio().post(
      _baseUrl + url,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer ' + Auth.accessToken
        },
      ),
    );
  } on DioError catch (e) {
    print(e);
    print(e.response.data);
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}
