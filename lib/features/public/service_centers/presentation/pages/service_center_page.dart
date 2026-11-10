import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/public/service_centers/domain/entites/service_center_entity.dart';
import 'package:pashboi/features/public/service_centers/presentation/bloc/service_center_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class ServiceCenterPage extends StatefulWidget {
  const ServiceCenterPage({super.key});

  @override
  State<ServiceCenterPage> createState() => _ServiceCenterPageState();
}

class _ServiceCenterLocation {
  const _ServiceCenterLocation({required this.center, required this.point});

  final ServiceCenterEntity center;
  final LatLng point;
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
  final MapController _mapController = MapController();
  LatLng _currentCenter = LatLng(23.7806, 90.4043);
  double _currentZoom = 11.0;

  List<_ServiceCenterLocation> _locationsFor(
    List<ServiceCenterEntity> serviceCenters,
  ) {
    return serviceCenters
        .map((center) {
          final latitude = double.tryParse(center.lat.trim());
          final longitude = double.tryParse(center.lng.trim());
          if (latitude == null ||
              longitude == null ||
              !latitude.isFinite ||
              !longitude.isFinite ||
              latitude < -90 ||
              latitude > 90 ||
              longitude < -180 ||
              longitude > 180) {
            return null;
          }
          return _ServiceCenterLocation(
            center: center,
            point: LatLng(latitude, longitude),
          );
        })
        .whereType<_ServiceCenterLocation>()
        .toList();
  }

  void _changeZoom(double amount) {
    _currentZoom = (_currentZoom + amount).clamp(3.0, 18.0);
    _mapController.move(_currentCenter, _currentZoom);
  }

  void _showDetailsDialog(BuildContext context, ServiceCenterEntity center) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(center.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (center.address.trim().isNotEmpty)
                  Text("📍 ${center.address}"),
                if (center.phone.trim().isNotEmpty) Text("📞 ${center.phone}"),
                if (center.email.trim().isNotEmpty) Text("✉️ ${center.email}"),
                if (center.time.trim().isNotEmpty) Text("⏰ ${center.time}"),
                if (center.inChargeInfos.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'In-Charge:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  for (var person in center.inChargeInfos) ...[
                    if (person.name.trim().isNotEmpty &&
                        person.designation.trim().isNotEmpty)
                      Text("👤 ${person.name} (${person.designation})"),
                    if (person.contactNumber.trim().isNotEmpty)
                      Text("📞 ${person.contactNumber}"),
                    if (person.email.trim().isNotEmpty)
                      Text("✉️ ${person.email}"),
                  ],
                ],
              ],
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServiceCenterBloc>()..add(FetchServiceCenterEvent()),
      child: PageContainer(
        child: BlocBuilder<ServiceCenterBloc, ServiceCenterState>(
          builder: (context, state) {
            if (state is ServiceCenterLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ServiceCenterSuccess) {
              final serviceCenters = state.serviceCenter;

              if (serviceCenters.isEmpty) {
                return const Center(
                  child: Text("No service centers available."),
                );
              }
              final locations = _locationsFor(serviceCenters);
              if (locations.isEmpty) {
                return const Center(
                  child: Text("Service center locations are unavailable."),
                );
              }

              return Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentCenter,
                      initialZoom: _currentZoom,
                      initialCameraFit: CameraFit.coordinates(
                        coordinates:
                            locations
                                .map((location) => location.point)
                                .toList(),
                        padding: const EdgeInsets.all(48),
                        maxZoom: 13,
                      ),
                      minZoom: 3,
                      maxZoom: 18,
                      onPositionChanged: (position, hasGesture) {
                        _currentCenter = position.center;
                        _currentZoom = position.zoom;
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.dhakacredit.cccul',
                      ),
                      MarkerLayer(
                        markers:
                            locations.map((location) {
                              return Marker(
                                point: location.point,
                                alignment: Alignment.bottomCenter,
                                width: 48,
                                height: 48,
                                child: GestureDetector(
                                  onTap:
                                      () => _showDetailsDialog(
                                        context,
                                        location.center,
                                      ),
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution('OpenStreetMap contributors'),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'zoomIn',
                          onPressed: () => _changeZoom(1),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'zoomOut',
                          onPressed: () => _changeZoom(-1),
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is ServiceCenterError) {
              return Center(child: Text("Error: ${state.error}"));
            }
            return const SizedBox.shrink(); // fallback
          },
        ),
      ),
    );
  }
}
