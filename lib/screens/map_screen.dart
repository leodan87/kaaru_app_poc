import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaaru_app_poc/providers/map_provider.dart';
import 'package:kaaru_app_poc/widgets/trip_info_widget.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaaru App - Mi Viaje'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            onMapCreated: mapProvider.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: mapProvider.initialPosition,
              zoom: 15.0,
            ),
            markers: mapProvider.markers,
            polylines: mapProvider.polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: false,
            padding: const EdgeInsets.only(bottom: 120.0),
          ),
          const TripInfoWidget(),
          // Posicionamos los botones a la derecha para evitar superposición
          Positioned(
            right: 16,
            bottom:
                140, // Subimos los botones para que no tapen el TripInfoWidget
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'create_route_btn',
                  onPressed: () {
                    mapProvider.createRouteToDestination();
                  },
                  label: const Text('Crear Ruta'),
                  icon: const Icon(Icons.directions),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  heroTag: 'start_simulation_btn',
                  onPressed: mapProvider.isRouteCreated
                      ? () => mapProvider.startSimulation()
                      : null,
                  label: const Text('Iniciar Simulación'),
                  icon: const Icon(Icons.play_arrow),
                  backgroundColor: mapProvider.isRouteCreated
                      ? Colors.green
                      : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
