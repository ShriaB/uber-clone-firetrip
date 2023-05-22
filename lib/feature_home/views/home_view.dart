import 'package:firetrip/common/auth/auth.dart';
import 'package:firetrip/common/constants/colors.dart';
import 'package:firetrip/common/constants/user_map_loc_info.dart';
import 'package:firetrip/common/routes/route_names.dart';
import 'package:firetrip/common/utils/utils.dart';
import 'package:firetrip/common/vehicles/vehicle_location.dart';
import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:firetrip/feature_home/services/location_services.dart';
import 'package:firetrip/feature_login/views/styles.dart';
import 'package:firetrip/feature_trip/services/directions.dart';
import 'package:firetrip/feature_trip/view_models/trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:intl/intl.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  /// User location, position and address
  LatLng? currentUserlocation;
  Position? currentUserPosition;
  // String? address;

  /// User info
  String? userName;
  String? userEmail;

  /// Pickup location
  LocationModel? _pickupLocation;
  LatLng? _pickupLatLng;

  /// DropOff Location
  LocationModel? _dropoffLocation;
  LatLng? _dropoffLatLng;

  /// Polyline points
  List<LatLng> _polylinePoints = [];
  bool _showPolyline = false;

  /// Map settings
  MapController? _mapController;
  // StreamSubscription? _subscription;
  bool _showUserMarker = false;
  bool _pickupConfirmed = false;
  bool _dropoffConfirmed = false;

  /// Navigation Details
  double distance = 0.0;
  double duration = 0.0;

  /// Provider
  late LocationServices _locationService;

  getUserLocation() async {
    // var locationService = ref.read(locationServiceProvider);
    _locationService.getCurrentUserPosition().then((position) {
      currentUserPosition = position;
      setState(() {
        currentUserlocation = LatLng(
            currentUserPosition!.latitude, currentUserPosition!.longitude);
        _showUserMarker = true;
      });
      _mapController?.move(currentUserlocation!, 15);

      getUserLocationAddress(currentUserlocation!);
      getPickupLocationAddress(currentUserlocation!);

      userName = currentUserInfo?.name;
      userEmail = currentUserInfo?.email;
    }).onError((error, stackTrace) {
      Utils.showRedSnackBar(context, error.toString());
    });
  }

  getUserLocationAddress(LatLng userLoc) async {
    _locationService
        .getUserAddressFromPosition(userLoc)
        .then((userLocationInfo) {
      ref
          .read(tripStateNotifierProvider.notifier)
          .updateUserLocationAddress(userLocationInfo);
    });
    setState(() {});
  }

  getPickupLocationAddress(LatLng pickLoc) async {
    _locationService
        .getUserAddressFromPosition(pickLoc)
        .then((userLocationInfo) {
      if (userLocationInfo != null) {
        setState(() {
          _pickupLocation = userLocationInfo;
          _pickupLatLng = LatLng(userLocationInfo.locationLatitude!,
              userLocationInfo.locationLongitude!);
        });
        ref
            .read(tripStateNotifierProvider.notifier)
            .updatePickupLocationAddress(userLocationInfo);
      }
      drawRouteBetweenSourceAndDestination();
    });
  }

  setDropOffLocation() async {
    var dropLoc = await Navigator.pushNamed(context, RouteNames.search);
    if (dropLoc != null) {
      setState(() {
        _dropoffLocation = dropLoc as LocationModel;
        print(
            "Drop location: ${_dropoffLocation?.locationLatitude}, ${_dropoffLocation?.locationLongitude}");
        _dropoffLatLng = LatLng(
            dropLoc.locationLatitude ?? UserMapLocInfo.userLocation.latitude,
            dropLoc.locationLongitude ?? UserMapLocInfo.userLocation.longitude);
      });
      // drawRouteBetweenSourceAndDestination();
    }
  }

  drawRouteBetweenSourceAndDestination() async {
    print("in drawRouteBetweenSourceAndDestination");
    if (_pickupLatLng != null && _dropoffLatLng != null) {
      print("in if");
      Map directionRes =
          await getDirectionsAPIResponse(_pickupLatLng!, _dropoffLatLng!);
      print("after call");
      print(directionRes);
      _polylinePoints = directionRes['points'];
      _showPolyline = true;
      _pickupConfirmed = true;
      _dropoffConfirmed = true;
      distance = directionRes['distance'];
      duration = directionRes['duration'];
      _mapController?.fitBounds(LatLngBounds.fromPoints(_polylinePoints),
          options: const FitBoundsOptions(
            padding: EdgeInsets.fromLTRB(50, 100, 50, 250),
          ));
      _mapController?.move(
          _mapController?.center ?? UserMapLocInfo.userLocation,
          _mapController?.zoom.roundToDouble() ?? 17);
      setState(() {});
    }
  }

  @override
  void initState() {
    _locationService = ref.read(locationServiceProvider);
    getUserLocation();
    _mapController = MapController();
    _mapController?.mapEventStream.listen((MapEvent mapEvent) {
      if (mapEvent is MapEventMoveEnd && !_pickupConfirmed) {
        LatLng point = mapEvent.center;
        print("${point.latitude}, ${point.longitude}");
        getPickupLocationAddress(point);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      /// Mapbox Map
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          pinchMoveThreshold: 20.0,
          center: currentUserlocation,
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
          if (_showPolyline)
            PolylineLayer(polylines: [
              Polyline(
                  points: _polylinePoints,
                  strokeWidth: 5.0,
                  color: primaryColor)
            ]),
          MarkerLayer(
            markers: [
              if (_showUserMarker)
                Marker(
                    height: 40,
                    width: 40,
                    point: currentUserlocation ?? UserMapLocInfo.userLocation!,
                    builder: (_) {
                      return Image.asset(
                          "assets/icons/user_location_marker.png");
                    }),
              Marker(
                  height: 40,
                  width: 40,
                  point: _dropoffLatLng ?? UserMapLocInfo.userLocation,
                  builder: (_) {
                    return Image.asset("assets/icons/user_location_marker.png");
                  }),
              for (var i = 0; i < allVehicles.length; i++)
                Marker(
                    height: 40,
                    width: 40,
                    point: allVehicles[i],
                    builder: (_) {
                      return Image.asset("assets/icons/car_icon.png");
                    }),
              if (_pickupConfirmed)
                Marker(
                    point: _pickupLatLng ?? UserMapLocInfo.userLocation,
                    builder: (_) {
                      return Image.asset(
                        "assets/icons/pickup_location_marker.png",
                        height: 35,
                        width: 35,
                      );
                    })
            ],
          ),
        ],
      ),

      /// Pickup Marker
      if (!_pickupConfirmed)
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: 35.0),
            child: Image.asset(
              "assets/icons/pickup_location_marker.png",
              height: 35,
              width: 35,
            ),
          ),
        ),

      /// Pickup and Dropoff Location card
      Positioned(
          top: 60,
          right: 20,
          left: 20,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  /// Pickup section
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 35.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "From",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              _pickupLocation != null
                                  ? "${_pickupLocation?.locationName}, ${_pickupLocation?.locationAddress}"
                                  : "Select pick up location",
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20.0,
                    thickness: 2,
                    color: primaryColor,
                  ),

                  /// Dropoff Section
                  GestureDetector(
                    onTap: () => setDropOffLocation(),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.navigation_rounded,
                          color: primaryColor,
                          size: 35.0,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "To",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                _dropoffLocation != null
                                    ? "${_dropoffLocation?.locationName}, ${_dropoffLocation?.locationAddress}"
                                    : "Where to?",
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    ]);
  }
}
