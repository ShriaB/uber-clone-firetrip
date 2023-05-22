import 'package:firetrip/common/constants/colors.dart';
import 'package:firetrip/common/constants/user_map_loc_info.dart';
import 'package:firetrip/common/routes/route_names.dart';
import 'package:firetrip/common/vehicles/vehicle_location.dart';
import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:firetrip/feature_login/views/styles.dart';
import 'package:firetrip/feature_trip/services/directions.dart';
import 'package:firetrip/feature_trip/view_models/trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class ReviewRideView extends ConsumerStatefulWidget {
  const ReviewRideView({super.key});

  @override
  ConsumerState<ReviewRideView> createState() => _PreviewRideViewState();
}

class _PreviewRideViewState extends ConsumerState<ReviewRideView> {
  MapController? _mapController;

  late TripViewModel viewModel;
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
      print(source.locationName);
      destination = viewModel.userDropOffLocation!;
      print(destination.locationName);
    }
    if (source.locationLatitude != null && source.locationLongitude != null) {
      sourceLatLng =
          LatLng(source.locationLatitude!, source.locationLongitude!);
      print(sourceLatLng.latitude);
    }
    if (destination.locationLatitude != null &&
        destination.locationLongitude != null) {
      destinationLatLng =
          LatLng(destination.locationLatitude!, destination.locationLongitude!);
      print(destinationLatLng.latitude);
    }
    _mapController = MapController();
  }

  getRoute() async {
    if (sourceLatLng != null && destinationLatLng != null) {
      print("in get route");
      Map directionRes =
          await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
      print("after call");
      print(directionRes);
      _polylinePoints = directionRes['points'];
      _distance = directionRes['distance'];
      _duration = directionRes['duration'];
      if (_polylinePoints != null) {
        print("in fitbounds");
        _mapController?.fitBounds(LatLngBounds.fromPoints(_polylinePoints!),
            options: const FitBoundsOptions(
              padding: EdgeInsets.fromLTRB(50, 100, 50, 250),
            ));
        _mapController?.move(
            _mapController?.center ?? UserMapLocInfo.userLocation,
            _mapController?.zoom.roundToDouble() ?? 17.0);

        setState(() {
          isRouteLoaded = true;
        });
      }
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
                additionalOptions: const {
                  /// public key
                  'accessToken': UserMapLocInfo.mapBoxAccessToken,

                  /// Tileset ID
                  'id': UserMapLocInfo.mapBoxStyleId,
                },
              ),
              if (isRouteLoaded)
                PolylineLayer(polylines: [
                  Polyline(
                      points: _polylinePoints!,
                      strokeWidth: 5.0,
                      color: primaryColor!)
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

/// Bottom Sheet widget
class BottomSheetWidget extends StatefulWidget {
  late LocationModel source;
  late LocationModel destination;
  num distance = 0.0;
  num duration = 0.0;

  BottomSheetWidget(
      {super.key,
      required this.source,
      required this.destination,
      required this.distance,
      required this.duration});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  String metersToKm(num meters) {
    return (meters / 1000).toStringAsFixed(2);
  }

  String getDropOffTime(num seconds) {
    var dropTime = DateTime.now().add(Duration(seconds: seconds.ceil()));
    return DateFormat.jm().format(dropTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${widget.source.locationName}",
                style: const TextStyle(fontSize: 18),
              ),
              const Icon(
                Icons.arrow_right_alt,
                color: primaryColor,
                size: 40,
              ),
              Text(
                "${widget.destination.locationName}",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/images/car.png",
                    height: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "FireTrip Prime",
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          "${metersToKm(widget.distance)} Km, ${getDropOffTime(widget.duration)}"),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "₹340.0",
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: textButtonStyle,
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.navigation);
            },
            child: const Text(
              "Start you ride",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
