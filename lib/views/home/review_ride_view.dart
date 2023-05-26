import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/constants/user_map_loc_info.dart';
import 'package:firetrip/global/vehicles/vehicle_location.dart';
import 'package:firetrip/models/location_model.dart';
import 'package:firetrip/services/mapbox_services/directions.dart';
import 'package:firetrip/provider/trip_state.dart';
import 'package:firetrip/widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class ReviewRideView extends ConsumerStatefulWidget {
  const ReviewRideView({super.key});

  @override
  ConsumerState<ReviewRideView> createState() => _PreviewRideViewState();
}

class _PreviewRideViewState extends ConsumerState<ReviewRideView> {
  MapController? _mapController;

  late TripState viewModel;
  late LocationModel source;
  late LatLng sourceLatLng;
  late LocationModel destination;
  late LatLng destinationLatLng;
  List<LatLng>? _polylinePoints;

  /// Navigation route Details
  num _distance = 0.0;
  num _duration = 0.0;

  bool isRouteLoaded = false;

  void initialise() {
    viewModel = ref.read(tripStateNotifierProvider);
    if (viewModel.userPickUpLocation != null &&
        viewModel.userDropOffLocation != null) {
      source = viewModel.userPickUpLocation!;
      destination = viewModel.userDropOffLocation!;
    }
    if (source.locationLatitude != null && source.locationLongitude != null) {
      sourceLatLng =
          LatLng(source.locationLatitude!, source.locationLongitude!);
    }
    if (destination.locationLatitude != null &&
        destination.locationLongitude != null) {
      destinationLatLng =
          LatLng(destination.locationLatitude!, destination.locationLongitude!);
    }
    _mapController = MapController();
  }

  getRoute() async {
    Map directionRes =
        await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
    _polylinePoints = directionRes['points'];
    _distance = directionRes['distance'];
    _duration = directionRes['duration'];
    if (_polylinePoints != null) {
      _mapController?.fitBounds(LatLngBounds.fromPoints(_polylinePoints!),
          options: const FitBoundsOptions(
            padding: EdgeInsets.fromLTRB(50, 100, 50, 250),
          ));
      _mapController?.move(
          _mapController?.center ?? UserMapLocInfo.userLocation,
          _mapController?.zoom.roundToDouble() ?? 17.0);

      ref.read(tripStateNotifierProvider.notifier).setDistance(_distance);
      setState(() {
        isRouteLoaded = true;
      });
    }
  }

  @override
  void initState() {
    initialise();
    super.initState();
    getRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: isRouteLoaded
            ? BottomSheetWidget(
                destination: destination,
                source: source,
                distance: _distance,
                duration: _duration,
              )
            : null,
        body: Stack(children: [
          /// Mapbox Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              pinchMoveThreshold: 20.0,
              maxZoom: 17.0,
              bounds: LatLngBounds.fromPoints(allVehicles),
              boundsOptions: const FitBoundsOptions(
                  padding: EdgeInsets.fromLTRB(50, 100, 50, 250),
                  forceIntegerZoomLevel: true),
            ),
            children: [
              TileLayer(
                /// Style url from third party - Mapbox
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/shriabqi/clhimmiwr01h601pg7wtk47pu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hyaWFicWkiLCJhIjoiY2xnMGJtbzRiMDIwdjNocDl3aXpxNjB6aiJ9.ixuCiBzs3OLVJ86jTymR1w',
                additionalOptions: {
                  /// public key
                  'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "",

                  /// Tileset ID
                  'id': UserMapLocInfo.mapBoxStyleId,
                },
              ),
              if (isRouteLoaded)
                PolylineLayer(polylines: [
                  Polyline(
                      points: _polylinePoints!,
                      strokeWidth: 5.0,
                      color: primaryColor)
                ]),
              MarkerLayer(
                markers: [
                  /// Source marker
                  Marker(
                      point: sourceLatLng,
                      builder: (_) {
                        return Image.asset(
                          "assets/icons/pickup_location_marker.png",
                          height: 35,
                          width: 35,
                        );
                      }),

                  /// Destination Marker
                  Marker(
                      height: 40,
                      width: 40,
                      point: destinationLatLng,
                      builder: (_) {
                        return Image.asset(
                            "assets/icons/user_location_marker.png");
                      }),

                  /// Vehicle markers
                  for (var i = 0; i < allVehicles.length; i++)
                    Marker(
                        height: 40,
                        width: 40,
                        point: allVehicles[i],
                        builder: (_) {
                          return Image.asset("assets/icons/car_icon.png");
                        }),
                ],
              ),
            ],
          ),
        ]));
  }
}
