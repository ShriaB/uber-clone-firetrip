import 'package:firetrip/common/auth/auth.dart';
import 'package:firetrip/common/constants/colors.dart';
import 'package:firetrip/common/constants/user_map_loc_info.dart';
import 'package:firetrip/common/utils/utils.dart';
import 'package:firetrip/feature_home/services/location_services.dart';
import 'package:firetrip/feature_trip/view_models/trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  /// User location, position and address
  loc.Location currentUserlocation = loc.Location();
  Position? currentUserPosition;
  // String? address;

  /// User info
  String? userName;
  String? userEmail;

  /// Pickup location
  LatLng? _pickupLocation;
  String _pickupAddress = "Set your pickup location";

  /// Dropoff Location
  LatLng? _dropoffLocation;
  String? _dropoffAddress = "Where to?";

  /// Map settings
  final _mapController = MapController();
  bool _showMarker = false;

  /// Provider
  late LocationServices _locationService;

  getUserLocation() async {
    // var locationService = ref.read(locationServiceProvider);
    _locationService.getCurrentUserPosition().then((position) {
      currentUserPosition = position;
      LatLng currentUserPositionLatLgn =
          LatLng(currentUserPosition!.latitude, currentUserPosition!.longitude);
      UserMapLocInfo.userLocation = currentUserPositionLatLgn;
      setState(() {
        _showMarker = true;
      });
      _mapController.move(currentUserPositionLatLgn, 14.5);

      getPickupLocationAddress(currentUserPositionLatLgn);

      userName = currentUserInfo?.name;
      userEmail = currentUserInfo?.email;
    }).onError((error, stackTrace) {
      Utils.showRedSnackBar(context, error.toString());
    });
  }

  getPickupLocationAddress(LatLng pickLoc) async {
    _locationService.getUserAddressFromPosition(pickLoc).then((address) {
      setState(() {
        _pickupLocation = pickLoc;
        _pickupAddress = address;
      });
    });
  }

  @override
  void initState() {
    _locationService = ref.read(locationServiceProvider);
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dropoffAddress =
        ref.watch(tripStateNotifierProvider).userDropOffLocation?.locationName;
    return Scaffold(
      body: Stack(children: [
        /// Mapbox Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            pinchMoveThreshold: 20.0,
            center: _pickupLocation,
            zoom: 13.0,
            maxZoom: 17.0,
            onPointerUp: (event, point) {
              print("${point.latitude}, ${point.longitude}");
              getPickupLocationAddress(point);
            },
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
            MarkerLayer(
              markers: [
                if (_showMarker)
                  Marker(
                      height: 40,
                      width: 40,
                      point: UserMapLocInfo.userLocation!,
                      builder: (_) {
                        return Image.asset(
                            "assets/icons/user_location_marker.png");
                      })
              ],
            )
          ],
        ),

        /// Pickup Marker
        if (_showMarker)
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                                ref
                                        .watch(tripStateNotifierProvider)
                                        .userPickUpLocation
                                        ?.locationName ??
                                    "Select pick up location",
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
                      onTap: () {},
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
                                  ref
                                          .watch(tripStateNotifierProvider)
                                          .userDropOffLocation
                                          ?.locationName ??
                                      "Where to",
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
      ]),
    );
  }
}
