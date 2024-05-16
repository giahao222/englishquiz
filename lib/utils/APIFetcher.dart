import 'dart:convert';

import 'package:http/http.dart' as http;

class APIFetcher {
  APIFetcher._();

  static APIFetcher? _instance;

  static APIFetcher get instance {
    _instance ??= APIFetcher._();
    return _instance!;
  }

  Future<dynamic> fetchAPI(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
