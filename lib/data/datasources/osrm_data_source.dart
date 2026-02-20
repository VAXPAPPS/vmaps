import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';

/// مصدر بيانات OSRM - حساب المسارات
class OsrmDataSource {
  static const String _baseUrl = 'https://router.project-osrm.org';

  final http.Client _client;

  OsrmDataSource({http.Client? client}) : _client = client ?? http.Client();

  /// حساب مسار بين نقطتين
  Future<RouteModel> getRoute(LatLng origin, LatLng destination) async {
    final coordinates =
        '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}';

    final uri = Uri.parse('$_baseUrl/route/v1/driving/$coordinates').replace(
      queryParameters: {
        'overview': 'full',
        'geometries': 'polyline',
        'steps': 'false',
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['code'] == 'Ok') {
        return RouteModel.fromOsrmJson(data, origin, destination);
      }

      throw Exception('OSRM routing failed: ${data['code']}');
    }

    throw Exception('OSRM request failed: ${response.statusCode}');
  }
}
