/// PLANTILLA DE CONFIGURACIÓN DE API KEYS
///
/// Instrucciones para desarrolladores:
/// 1. Copia este archivo y renómbralo a 'api_keys.dart'
/// 2. Reemplaza 'TU_CLAVE_GOOGLE_MAPS_AQUI' con tu clave API real
/// 3. Nunca compartas el archivo api_keys.dart real en repositorios públicos
///
/// Para obtener una clave de Google Maps:
/// 1. Ve a: https://console.cloud.google.com/
/// 2. Crea un proyecto o selecciona uno existente
/// 3. Habilita las APIs: Maps SDK for Android, Maps SDK for iOS, Directions API
/// 4. Crea credenciales (API Key)
/// 5. Configura restricciones según tus necesidades

class ApiKeys {
  /// Clave API de Google Maps para servicios de direcciones y mapas
  static const String googleMapsApiKey = "TU_CLAVE_GOOGLE_MAPS_AQUI";

  /// URL base para el servicio de direcciones de Google Maps
  static const String directionsBaseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  // Aquí puedes agregar más claves API según necesites:
  // static const String otherApiKey = "otra_clave_aqui";
}
