import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kaaru_app_poc/models/directions_model.dart';
import 'package:kaaru_app_poc/config/api_keys.dart';

class DirectionsService {
  // Obtenemos la clave API desde la configuración centralizada
  final String _apiKey = ApiKeys.googleMapsApiKey;
  final String _baseUrl = ApiKeys.directionsBaseUrl;

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&language=es&key=$_apiKey',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return Directions.fromMap(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
