import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

/// مصدر بيانات Nominatim - بحث أماكن و Reverse Geocoding
class NominatimDataSource {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  final http.Client _client;

  NominatimDataSource({http.Client? client}) : _client = client ?? http.Client();

  /// البحث عن أماكن بالاسم
  Future<List<PlaceModel>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse('$_baseUrl/search').replace(
      queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': '1',
        'limit': '10',
        'accept-language': 'ar,en',
      },
    );

    final response = await _client.get(
      uri,
      headers: {'User-Agent': 'VaxpMaps/1.0'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PlaceModel.fromNominatimJson(e)).toList();
    }

    throw Exception('Nominatim search failed: ${response.statusCode}');
  }

  /// Reverse Geocoding - الحصول على عنوان من إحداثيات
  Future<PlaceModel?> reverseGeocode(double lat, double lon) async {
    final uri = Uri.parse('$_baseUrl/reverse').replace(
      queryParameters: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'format': 'json',
        'addressdetails': '1',
        'accept-language': 'ar,en',
      },
    );

    final response = await _client.get(
      uri,
      headers: {'User-Agent': 'VaxpMaps/1.0'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['error'] != null) return null;
      return PlaceModel.fromNominatimJson(data);
    }

    return null;
  }
}
