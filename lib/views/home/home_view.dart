import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/constants/user_map_loc_info.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/global/utils/utils.dart';
import 'package:firetrip/global/vehicles/vehicle_location.dart';
import 'package:firetrip/models/location_model.dart';
import 'package:firetrip/services/location_services/location_services.dart';
import 'package:firetrip/provider/trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

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

  /// Pickup location
  LocationModel? _pickupLocation;
  LatLng? _pickupLatLng;

  /// DropOff Location
  LocationModel? _dropoffLocation;
  LatLng? _dropoffLatLng;

  /// Map settings
  MapController? _mapController;

  /// Once map is loaded this is set to true to show the user location marker
  bool _showUserMarker = false;

  /// Provider
  late LocationServices _locationService;

  /// Gets the user current location
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
    }).onError((error, stackTrace) {
      Utils.showRedSnackBar(context, error.toString());
    });
  }

  /// Takes the location coordinates and gets the location address
  /// calls [updateUserLocationAddress] in [TripStateNotifier]
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

  /// Takes the location coordinates and gets the location address
  /// calls [updatePickupLocationAddress] in [TripStateNotifier]
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
    });
  }

  @override
  void initState() {
    _locationService = ref.read(locationServiceProvider);
    getUserLocation();
    _mapController = MapController();

    /// On map move get the pick up location
    _mapController?.mapEventStream.listen((MapEvent mapEvent) {
      if (mapEvent is MapEventMoveEnd) {
        LatLng point = mapEvent.center;
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
            additionalOptions: {
              /// public key
              'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "",

              /// Tileset ID
              'id': UserMapLocInfo.mapBoxStyleId,
            },
          ),
          MarkerLayer(
            markers: [
              if (_showUserMarker)

                /// User location Marker
                Marker(
                    height: 40,
                    width: 40,
                    point: currentUserlocation ?? UserMapLocInfo.userLocation,
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

      /// Pickup Marker
      Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35.0),
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
              padding: const EdgeInsets.all(20.0),
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
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.search),
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
