import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'mapa_controller.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapaController()..init(),
      child: const _MapaPage(),
    );
  }
}

class _MapaPage extends StatefulWidget {
  const _MapaPage({super.key});
  @override
  State<_MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<_MapaPage> {
  final Completer<GoogleMapController> _mapCtrl = Completer();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<MapaController>();

    if (ctrl.loading || ctrl.userCenter == null) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Mapa de Canchas',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: ctrl.setQuery,
                decoration: InputDecoration(
                  hintText: 'Buscar cancha',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: ctrl.userCenter!,
                      zoom: 14.5,
                    ),
                    myLocationEnabled: ctrl.hasLocationPermission, // 👈 seguro
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    compassEnabled: true,
                    onMapCreated: (c) => _mapCtrl.complete(c),
                    markers: _buildMarkers(ctrl),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final c = ctrl.seleccionada;
                    if (c == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona una cancha en el mapa.'),
                        ),
                      );
                      return;
                    }
                    _showDetalles(context, c);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Ver detalles / Reservar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers(MapaController ctrl) {
    final Set<Marker> markers = {};
    for (final c in ctrl.visibles) {
      final isSelected = ctrl.seleccionada?.id == c.id;
      markers.add(
        Marker(
          markerId: MarkerId(c.id),
          position: c.pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueOrange,
          ),
          onTap: () async {
            ctrl.select(c);
            if (_mapCtrl.isCompleted) {
              final map = await _mapCtrl.future;
              map.animateCamera(CameraUpdate.newLatLngZoom(c.pos, 16));
            }
          },
          infoWindow: InfoWindow(
            title: c.nombre,
            snippet:
                'L ${c.precioHora.toStringAsFixed(0)}/hora • ⭐ ${c.rating}',
            onTap: () => _showDetalles(context, c),
          ),
        ),
      );
    }
    return markers;
  }

  void _showDetalles(BuildContext context, Cancha c) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.nombre,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(c.direccion, style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text('L ${c.precioHora.toStringAsFixed(0)}/hora'),
                  ),
                  const SizedBox(width: 8),
                  Chip(label: Text('⭐ ${c.rating}')),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reservando: ${c.nombre}')),
                    );
                  },
                  child: const Text('Reservar'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
