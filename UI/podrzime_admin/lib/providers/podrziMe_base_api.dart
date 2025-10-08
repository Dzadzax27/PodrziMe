import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:podrzime_admin/models/search_result.dart';
import 'package:podrzime_admin/utils/util.dart';

class ApiProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = '';

  ApiProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment(
      "baseUrl",
      defaultValue: "https://localhost:7220/",
    );
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];
      var dataResult = data['resultList'];
      print('Ovdje sam ${result.count}');
      print('Ovdje sam2 ${data}');

      for (var item in data['result']) {
        print('Result ${fromJson(item)}');
        result.result.add(fromJson(item));
      }
      print('Resuilt ${result}');
      return result;
    } else {
      throw new Exception("Unknown error");
    }
    // print("response: ${response.request} ${response.statusCode}, ${response.body}");
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      print(response.body);
      throw new Exception("Something bad happened please try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? '';
    String password = Authorization.password ?? '';

    print("passed creds: $username, $password");

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

  T fromJson(data) {
    throw Exception("Method not implemented");
  }
}
