import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:podrzime_mobile/modals/searchResults.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/utils/authorization.dart';
import 'package:podrzime_mobile/utils/errorCode.dart';

class ApiProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint;

  HttpClient client = new HttpClient();
  IOClient? http;

  ApiProvider(String endpoint) {
    _baseUrl = const String.fromEnvironment(
      "baseUrl",
      defaultValue: "https://10.0.2.2:7220/",
    );
    print("baseurl: $_baseUrl");

    if (_baseUrl == null || !_baseUrl!.endsWith("/")) {
      _baseUrl = (_baseUrl ?? '') + "/";
    }
    _endpoint = endpoint;
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<List<T>> get([dynamic search]) async {
    var url = "$_baseUrl$_endpoint";

    if (search != null) {
      String queryString = getQueryString(search);
      url = url + "?" + queryString;
    }

    var uri = Uri.parse(url);

    print('uriii ${uri}');

    Map<String, String> headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<T>().toList();
    } else {
      throw Exception("Exception... handle this gracefully");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    print('Requuuuusetttt ${jsonRequest}');
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    print('Requuuuusetttt ${response.statusCode}  ${response.body}');
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  bool isValidResponse(Response response) {
    // final responseData = jsonDecode(response.body);
    // final errorCode = responseData['code'];

    // print('Errroooor code $errorCode');

    // if (errorCode == 2627 || errorCode == 2627) {
    //   ErrorCode.errorUniqueField = true;
    //   print('Here i am');
    //   return true;
    // }
    if (response.statusCode < 299) {
      ErrorCode.errorUniqueField = false;
      return true;
    } else if (response.statusCode == 401) {
      ErrorCode.errorUniqueField = true;
      throw new Exception("Unauthorized");
    } else {
      ErrorCode.errorUniqueField = true;
      throw new Exception("Something bad happened please try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? '';
    String password = Authorization.password ?? '';

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {"Content-Type": "application/json", "Authorization": basicAuth};
  }

  String getQueryString(
    Map params, {
    String prefix = '&',
    bool inRecursion = false,
  }) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query += getQueryString(
            {k: v},
            prefix: '$prefix$key',
            inRecursion: true,
          );
        });
      }
    });
    return query;
  }

  Future<T> update(int id, [dynamic request]) async {
    print('here i am noww');
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<List<Takmicar>> getRecommendations(
    int donorId, [
    dynamic additionalData,
  ]) async {
    var url = Uri.parse("$_baseUrl$_endpoint/$donorId/recommend");
    var headers = createHeaders();

    final response = await http!.get(url, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);

      // mapiramo JSON listu na List<Kandidat>
      return (data as List)
          .map((x) => Takmicar.fromJson(x as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch recommendations");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }
}
