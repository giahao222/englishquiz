import 'dart:convert';

import 'package:http/http.dart' as http;

class APIFetcher {
  APIFetcher._();

  static APIFetcher? _instance;

  static APIFetcher get instance {
    _instance ??= APIFetcher._();
    return _instance!;
  }

  Future<String> fetchHints(String word) async {
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load hints');
    }
  }
}
