import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'mapa_controller.dart';
import 'widgets/search_bar.dart';
import 'widgets/reservar_button.dart';

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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Mostrar loading mientras se inicializa
    if (ctrl.loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Cargando mapa...',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Solicitando permisos de ubicación',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Mostrar error si no se pudo cargar
    if (ctrl.userCenter == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: isTablet ? 80 : 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar el mapa',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (ctrl.errorMessage != null)
                    Text(
                      ctrl.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ctrl.init();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 20,
                        vertical: isTablet ? 16 : 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!ctrl.hasLocationPermission)
                    TextButton.icon(
                      onPressed: () {
                        ctrl.openLocationSettings();
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Configurar permisos'),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isTablet ? 16 : 8),
                      _buildHeader(isTablet, ctrl),
                      SizedBox(height: isTablet ? 20 : 12),
                      _buildSearchBar(ctrl),
                      SizedBox(height: isTablet ? 20 : 12),
                      _buildMap(ctrl, constraints, isTablet),
                      SizedBox(height: isTablet ? 24 : 16),
                      _buildReservarButton(ctrl, context),
                      SizedBox(height: isTablet ? 16 : 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet, MapaController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mapa de Canchas',
          style: TextStyle(
            fontSize: isTablet ? 36 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (ctrl.query.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '${ctrl.visibles.length} resultado${ctrl.visibles.length == 1 ? '' : 's'} encontrado${ctrl.visibles.length == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
        if (!ctrl.hasLocationPermission) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, 
                     color: Colors.orange.shade600, 
                     size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sin permisos de ubicación',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchBar(MapaController ctrl) {
    return MapSearchBar(
      hint: 'Buscar cancha por nombre o dirección',
      onChanged: (value) {
        debugPrint('Mapa recibió búsqueda: "$value"');
        ctrl.setQuery(value);
      },
    );
  }

  Widget _buildMap(MapaController ctrl, BoxConstraints constraints, bool isTablet) {
    final mapHeight = isTablet 
        ? constraints.maxHeight * 0.5 
        : constraints.maxHeight * 0.45;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: mapHeight.clamp(300.0, 500.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: ctrl.userCenter!,
            zoom: 14.5,
          ),
          myLocationEnabled: ctrl.hasLocationPermission,
          myLocationButtonEnabled: ctrl.hasLocationPermission,
          zoomControlsEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            debugPrint('Mapa creado correctamente');
            if (!_mapCtrl.isCompleted) {
              _mapCtrl.complete(controller);
            }
          },
          markers: _buildMarkers(ctrl),
        ),
      ),
    );
  }

  Widget _buildReservarButton(MapaController ctrl, BuildContext context) {
    return ReservarButton(
      onTap: () {
        final c = ctrl.seleccionada;
        if (c == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selecciona una cancha en el mapa.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        _showDetalles(context, c);
      },
    );
  }

  Set<Marker> _buildMarkers(MapaController ctrl) {
    final Set<Marker> markers = {};
    
    debugPrint('Construyendo ${ctrl.visibles.length} marcadores');
    
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
            debugPrint('Marcador tocado: ${c.nombre}');
            ctrl.select(c);
            if (_mapCtrl.isCompleted) {
              final map = await _mapCtrl.future;
              map.animateCamera(CameraUpdate.newLatLngZoom(c.pos, 16));
            }
          },
          infoWindow: InfoWindow(
            title: c.nombre,
            snippet: 'L ${c.precioHora.toStringAsFixed(0)}/hora • ⭐ ${c.rating}',
            onTap: () => _showDetalles(context, c),
          ),
        ),
      );
    }
    
    debugPrint('Marcadores construidos: ${markers.length}');
    return markers;
  }

  void _showDetalles(BuildContext context, Cancha c) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: size.height * 0.7,
            minHeight: size.height * 0.3,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 24 : 16,
              isTablet ? 16 : 8,
              isTablet ? 24 : 16,
              isTablet ? 32 : 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.nombre,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: isTablet ? 18 : 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              c.direccion,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 16 : 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            avatar: Icon(
                              Icons.attach_money,
                              size: isTablet ? 18 : 16,
                            ),
                            label: Text(
                              'L ${c.precioHora.toStringAsFixed(0)}/hora',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ),
                          Chip(
                            avatar: Icon(
                              Icons.star,
                              size: isTablet ? 18 : 16,
                              color: Colors.amber,
                            ),
                            label: Text(
                              '${c.rating}',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 24 : 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reservando: ${c.nombre}'),
                          backgroundColor: Colors.green,
                          action: SnackBarAction(
                            label: 'Ver',
                            onPressed: () {
                              // Aquí puedes navegar a la pantalla de reserva
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      'Reservar ahora',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 20 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 8),
              ],
            ),
          ),
        );
      },
    );
  }
}