import 'dart:convert';

import 'package:blood_donation/model/donor.dart';
import 'package:http/http.dart' as http;

/// REST API adapter. Supply the real API base URL from your backend.
/// This file is intentionally not connected to the UI until a real endpoint exists.
class ApiDonorRepository {
  ApiDonorRepository({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<Donor>> fetchDonors() async {
    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final uri = Uri.parse('$normalizedBaseUrl/donors');
    final response = await _client.get(
      uri,
      headers: const {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Donors API failed with HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) {
      throw const FormatException('Expected the API response to be a JSON list.');
    }

    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('A donor item is not a JSON object.');
      }
      return Donor.fromJson(item);
    }).toList();
  }

  void dispose() => _client.close();
}
