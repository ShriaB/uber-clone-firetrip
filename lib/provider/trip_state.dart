import 'package:firetrip/models/location_model.dart';
import 'package:firetrip/models/trip_model.dart';
import 'package:firetrip/services/firebase_services/trips_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [TripState] is a shared state storing information about the current trip
/// [currentUserLocation] User Location
/// [userPickUpLocation]  Pickup Location set by user
/// [userDropOffLocation] Destination Location user wants to travel to
/// [pickupTime] Pick up time for the trip
/// [dropOffTime] Dropoff time
/// [distance] Distance between source location and destination location
/// [allTripInfoList] Stores all the trips (trip history) of the user
/// [tripCount] Total number of trips of the user

class TripState {
  LocationModel? currentUserLocation, userPickUpLocation, userDropOffLocation;
  DateTime? pickupTime, dropOffTime;
  num? distance;
  static List<TripModel> allTripInfoList = [];
  static int tripCount = 0;
}

/// [TripStateNotifier] StateNotifier that is used to update [TripState]

class TripStateNotifier extends StateNotifier<TripState> {
  TripStateNotifier() : super(TripState());

  void updateUserLocationAddress(LocationModel? currentLocation) {
    if (currentLocation != null) {
      state.currentUserLocation = currentLocation;
    }
  }

  void updatePickupLocationAddress(LocationModel? userPickUpaddress) {
    if (userPickUpaddress != null) {
      state.userPickUpLocation = userPickUpaddress;
    }
  }

  void updateDropoffLocationAddress(LocationModel? userDropOffaddress) {
    if (userDropOffaddress != null) {
      state.userDropOffLocation = userDropOffaddress;
    }
  }

  void setPickUpTime() {
    state.pickupTime = DateTime.now();
  }

  void setDropOffTime() {
    state.dropOffTime = DateTime.now();
  }

  void setDistance(num distance) {
    state.distance = distance;
  }

  /// Fetched all trips from Firebase
  /// And stored in [allTripInfoList]
  /// Update [tripCount] to the length of list
  static Future<void> getTrips() async {
    TripState.allTripInfoList = await TripsService.getAllTrips();
    TripState.tripCount = TripState.allTripInfoList.length;
  }

  /// Add a trip to all trip list
  /// Increment tripCount
  static void addTripToTripList(trip) {
    TripState.allTripInfoList.add(trip);
    TripState.tripCount++;
  }

  /// Reset after a trip is over
  void reset() {
    state.currentUserLocation = null;
    state.userPickUpLocation = null;
    state.userDropOffLocation = null;
    state.pickupTime = null;
    state.dropOffTime = null;
    state.distance = null;
  }
}

final tripStateNotifierProvider =
    StateNotifierProvider<TripStateNotifier, TripState>(
        (ref) => TripStateNotifier());
