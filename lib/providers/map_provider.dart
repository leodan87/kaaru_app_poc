import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaaru_app_poc/models/directions_model.dart';
import 'package:kaaru_app_poc/services/directions_service.dart';
import 'dart:ui' as ui;

class MapProvider with ChangeNotifier {
  // --- PROPIEDADES ---
  static const LatLng _initialPosition = LatLng(0.0897, -76.8864);
  LatLng get initialPosition => _initialPosition;

  LatLng? _userLocation;
  LatLng? get userLocation => _userLocation;

  static const LatLng _destination = LatLng(
    0.0897,
    -76.8864,
  ); // Parque Central de Lago Agrio
  LatLng get destination => _destination;

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  final Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;

  String? _tripDistance;
  String? get tripDistance => _tripDistance;

  String? _tripDuration;
  String? get tripDuration => _tripDuration;

  bool _isCameraPositioned = false;

  final DirectionsService _directionsService = DirectionsService();

  // --- Propiedades para la Simulación ---
  BitmapDescriptor? _carIcon;
  Timer? _simulationTimer;
  int _currentStep = 0;
  List<LatLng> _routePoints = [];

  bool _isRouteCreated = false;
  bool get isRouteCreated => _isRouteCreated;

  MapProvider() {
    startUserLocationTracking();
    _loadCarIcon();
  }

  // --- MÉTODOS ---

  Future<void> _loadCarIcon() async {
    final Uint8List markerIconBytes = await getBytesFromAsset(
      'assets/car_icon.png',
      80,
    );
    _carIcon = BitmapDescriptor.fromBytes(markerIconBytes);
    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  Future<void> startUserLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever)
      return Future.error('Location permissions are permanently denied');

    Geolocator.getPositionStream().listen((Position position) {
      _userLocation = LatLng(position.latitude, position.longitude);
      _updateUserMarker();
      if (!_isCameraPositioned) {
        moveCameraToUserLocation();
        _isCameraPositioned = true;
      }
      notifyListeners();
    });
  }

  void _updateUserMarker() {
    if (_userLocation != null) {
      _markers.removeWhere((marker) => marker.markerId.value == 'userLocation');
      final userMarker = Marker(
        markerId: const MarkerId('userLocation'),
        position: _userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'Mi Ubicación'),
      );
      _markers.add(userMarker);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void moveCameraToUserLocation() {
    if (_mapController != null && _userLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_userLocation!, 16.0),
      );
    }
  }

  Future<void> createRouteToDestination() async {
    if (_userLocation == null) return;
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: const InfoWindow(title: 'Destino'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    final Directions? directionsData = await _directionsService.getDirections(
      origin: _userLocation!,
      destination: _destination,
    );
    if (directionsData == null) return;
    _tripDistance = directionsData.totalDistance;
    _tripDuration = directionsData.totalDuration;
    _routePoints = directionsData.polylinePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    final routePolyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.indigo,
      width: 5,
      points: _routePoints,
    );
    _polylines.add(routePolyline);

    _isRouteCreated = true;

    notifyListeners();
  }

  void startSimulation() {
    if (!_isRouteCreated || _routePoints.isEmpty || _carIcon == null) return;
    _simulationTimer?.cancel();
    _addCarMarker(_routePoints[0]);
    _currentStep = 0;

    _simulationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _currentStep++;
      if (_currentStep >= _routePoints.length) {
        timer.cancel();
      } else {
        final newPosition = _routePoints[_currentStep];
        _addCarMarker(newPosition);
        notifyListeners();
      }
    });
  }

  void _addCarMarker(LatLng position) {
    _markers.removeWhere((marker) => marker.markerId.value == 'car');
    final carMarker = Marker(
      markerId: const MarkerId('car'),
      position: position,
      icon: _carIcon!,
      anchor: const Offset(0.5, 0.5),
    );
    _markers.add(carMarker);
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
