import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:firetrip/feature_trip/view_models/trip_view_model.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class TurnByTurnNavigation extends ConsumerStatefulWidget {
  const TurnByTurnNavigation({super.key});

  @override
  ConsumerState<TurnByTurnNavigation> createState() =>
      _TurnByTurnNavigationState();
}

class _TurnByTurnNavigationState extends ConsumerState<TurnByTurnNavigation> {
  late LocationModel source, destination;
  late WayPoint sourceWayPoint, destinationWayPoint;
  var wayPoints = <WayPoint>[];

  late MapBoxNavigation navigation;
  late MapBoxOptions _options;
  late double? remainingDistance, remainingDuration;
  late MapBoxNavigationViewController _controller;
  final bool _isMultipleStop = false;
  String instructions = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  late TripViewModel viewModel;

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

  Future<void> initialise() async {
    print("in initialise of navigation");
    if (!mounted) {
      return;
    }

    navigation = MapBoxNavigation.instance;
    // _controller = MapBoxNavigationViewController(id, (value) { })
    navigation.registerRouteEventListener((value) {
      onRouteEvent(value);
    });
    _options = MapBoxOptions(
      zoom: 18.0,
      bannerInstructionsEnabled: true,
      voiceInstructionsEnabled: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      isOptimized: true,
      units: VoiceUnits.metric,
      simulateRoute: true,
      language: 'en',
    );
    getWayPoints();
    print("Start of navigation");
    await navigation.startNavigation(wayPoints: wayPoints, options: _options);
    // print("End of navigation");
  }

  Future<void> onRouteEvent(RouteEvent e) async {
    remainingDistance = await navigation.getDistanceRemaining();
    remainingDuration = await navigation.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instructions = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await navigation.finishNavigation();
        }
        break;
      case MapBoxEvent.navigation_cancelled:
      case MapBoxEvent.navigation_finished:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }

    setState(() {});
  }

  @override
  void initState() {
    print("in initstate of navigation");
    // TODO: implement initState
    viewModel = ref.read(tripStateNotifierProvider);
    if (viewModel.userPickUpLocation != null &&
        viewModel.userDropOffLocation != null) {
      source = viewModel.userPickUpLocation!;
      destination = viewModel.userDropOffLocation!;
    }
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    print("in build of navigation");
    // initialise();
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: MapBoxNavigationView(
            options: _options,
            onRouteEvent: onRouteEvent,
            onCreated: (MapBoxNavigationViewController controller) async {
              _controller = controller;
              _controller.buildRoute(wayPoints: wayPoints);
              _controller.startNavigation();
            }),
      ),
    );
  }
}
