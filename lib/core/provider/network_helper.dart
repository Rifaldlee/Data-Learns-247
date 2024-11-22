import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:data_learns_247/core/provider//api_exception.dart';
import 'package:data_learns_247/core/tools/shared_pref_util.dart';

typedef NetworkCallBack<R> = R Function(dynamic);

class NetworkHelper {
  const NetworkHelper._();

  static String concatUrlQP(String url, Map<String, String>? queryParameters) {
    if (url.isEmpty) return url;
    if (queryParameters == null || queryParameters.isEmpty) return url;

    final StringBuffer stringBuffer = StringBuffer("$url?");
    queryParameters.forEach((key, value) {
      if (value.trim().isEmpty) return;
      if (value.contains(' ')) throw Exception('Invalid Input Exception');
      stringBuffer.write('$key=$value&');
    });
    final result = stringBuffer.toString();
    return result.substring(0, result.length - 1);
  }

  static R filterResponse<R>({
    required NetworkCallBack callBack,
    required http.Response response,
  }) {
    switch (response.statusCode) {
      case 200:
        {
          if (response.headers['set-cookie'] != null) {
            List<String> cookies = response.headers['set-cookie']!.split(",");

            String? toBeStoredCookie = cookies.lastWhereOrNull((element) =>
                element.contains("DataLearns247_logged_in"));

            if (!toBeStoredCookie.isEmptyOrNull) {
              SharedPrefUtil.storeCookie(toBeStoredCookie!.split(";")[0]);
            }
          }
          return callBack(jsonDecode(response.body));
        }
      case 400:
      {
        final responseBody = jsonDecode(response.body);
        if (responseBody['data'] != null && responseBody['data']['errorCode'] == 48) {
          throw LoginException(responseBody['data']['message']);
        }
        if (responseBody != null && responseBody['code'] == 406) {
          throw RegisterException(responseBody['message']);
        }
        throw BadRequestException(response.body.toString());
      }
      case 401:
        throw UnauthorizedException(response.body.toString());
      case 403:
        throw ForbiddenException(response.body.toString());
      case 404:
        throw NotFoundException(response.body.toString());
      case 408:
        throw RequestTimeoutException(response.body.toString());
      case 500:
        throw InternalServerException(response.body.toString());
      case 502:
        throw BadGatewayException(response.body.toString());
      case 503:
        throw ServiceUnavailableException(response.body.toString());
      case 504:
        throw GatewayTimeoutException(response.body.toString());
      default:
        throw FetchDataException(response.statusCode.toString());
    }
  }
}