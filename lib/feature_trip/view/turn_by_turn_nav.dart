import 'dart:async';
import 'package:firetrip/common/constants/colors.dart';
import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:firetrip/feature_login/views/styles.dart';
import 'package:firetrip/feature_trip/view_models/trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox/flutter_mapbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class SampleNavigationApp extends ConsumerStatefulWidget {
  const SampleNavigationApp({super.key});

  @override
  ConsumerState createState() => _SampleNavigationAppState();
}

class _SampleNavigationAppState extends ConsumerState<SampleNavigationApp> {
  String _platformVersion = 'Unknown';
  String? _instruction = "";
  late TripViewModel viewModel;
  late LocationModel source, destination;
  late WayPoint sourceWayPoint, destinationWayPoint;
  var wayPoints = <WayPoint>[];

  MapBoxNavigation? _directions;
  MapBoxOptions? _options;

  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  dynamic prevEvent;

  @override
  void initState() {
    viewModel = ref.read(tripStateNotifierProvider);
    if (viewModel.userPickUpLocation != null &&
        viewModel.userDropOffLocation != null) {
      source = viewModel.userPickUpLocation!;
      destination = viewModel.userDropOffLocation!;
    }
    super.initState();
    Future(() => initialize());
  }

  void getWayPoints() {
    sourceWayPoint = WayPoint(
        name: "Source",
        latitude: source.locationLatitude,
        longitude: source.locationLongitude);
    destinationWayPoint = WayPoint(
        name: "Destination",
        latitude: destination.locationLatitude,
        longitude: destination.locationLongitude);
    wayPoints.add(sourceWayPoint);
    wayPoints.add(destinationWayPoint);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    try {
      Location location = Location();
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      locationData = await location.getLocation();

      getWayPoints();

      _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
      var options = MapBoxOptions(
          initialLatitude: 36.1175275,
          initialLongitude: -115.1839524,
          // avoid: ["motorway", "toll"],
          zoom: 13.0,
          tilt: 0.0,
          bearing: 0.0,
          enableRefresh: true,
          alternatives: true,
          voiceInstructionsEnabled: true,
          bannerInstructionsEnabled: true,
          allowsUTurnAtWayPoints: true,
          mode: MapBoxNavigationMode.drivingWithTraffic,
          units: VoiceUnits.imperial,
          simulateRoute: true,
          longPressDestinationEnabled: true,
          pois: wayPoints,
          mapStyleUrlDay: "mapbox://styles/mapbox/navigation-day-v1",
          mapStyleUrlNight: "mapbox://styles/mapbox/navigation-night-v1",
          language: "en");

      setState(() {
        _options = options;
      });
    } catch (err) {
      print(err);
    }
  }

  void showRoute() {
    List<String> avoids = [];

    var lat = "53.157863";
    var lon = "-3.055103";
    avoids.add("point($lon $lat)");

    var options = MapBoxOptions(
        avoid: avoids, maxHeight: "5.0", maxWeight: "2.5", maxWidth: "1.9");

    _isMultipleStop = wayPoints.length > 2;
    _controller!.buildRoute(wayPoints: wayPoints, options: options);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey,
          child: _options != null
              ? MapBoxNavigationView(
                  options: _options,
                  onRouteEvent: _onEmbeddedRouteEvent,
                  onCreated: (MapBoxNavigationViewController controller) async {
                    _controller = controller;
                    _controller!.initialize();
                    _directions!.startNavigation(
                        wayPoints: wayPoints, options: _options!);
                  })
              : null,
        ),
        Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: ElevatedButton(
              style: textButtonStyle,
              onPressed: () {
                _directions?.finishNavigation();
              },
              child: Text("Arrived at destination"),
            ))
      ],
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _controller!.distanceRemaining;
    _durationRemaining = await _controller!.durationRemaining;
    // print(e.eventType);

    if (prevEvent == null) {
      prevEvent = e.eventType;
    } else if (prevEvent == e.eventType) {
      return;
    }

    switch (e.eventType) {
      case MapBoxEvent.annotation_tapped:
        var annotation = _controller!.selectedAnnotation;
        // print(annotation);
        break;
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller!.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {
      prevEvent = e.eventType;
    });
  }
}
