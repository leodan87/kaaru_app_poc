import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaaru_app_poc/providers/map_provider.dart';

class TripInfoWidget extends StatelessWidget {
  const TripInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider para obtener los datos.
    final mapProvider = context.watch<MapProvider>();

    // Si no hay datos de viaje, no mostramos nada.
    if (mapProvider.tripDistance == null || mapProvider.tripDuration == null) {
      return const SizedBox.shrink(); // Un widget vacío que no ocupa espacio.
    }

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoColumn(
                Icons.directions_car,
                mapProvider.tripDistance!,
                'Distancia',
              ),
              _buildInfoColumn(
                Icons.timer,
                mapProvider.tripDuration!,
                'Duración Estimada',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Un método auxiliar para no repetir código al crear las columnas de información.
  Widget _buildInfoColumn(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.indigo, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
