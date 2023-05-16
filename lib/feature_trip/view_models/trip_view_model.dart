import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripViewModel {
  LocationModel? currentUserLocation, userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  // List<String> tripHistoryKeyList = [];
  // List<TripHistoryModel> allTripInfoList = [];
}

class TripStateNotifier extends StateNotifier<TripViewModel> {
  TripStateNotifier() : super(TripViewModel());

  void updateUserLocationAddress(LocationModel? currentLocation) {
    print("in viewmodel");
    if (currentLocation != null) {
      state.currentUserLocation = currentLocation;
      print(state.currentUserLocation?.locationName);
    }
  }

  void updatePickupLocationAddress(LocationModel? userPickUpaddress) {
    print("in viewmodel");
    if (userPickUpaddress != null) {
      state.userPickUpLocation = userPickUpaddress;
      print(state.userPickUpLocation?.locationName);
    }
  }

  void updateDropoffLocationAddress(LocationModel? userDropOffaddress) {
    if (userDropOffaddress != null) {
      state.userDropOffLocation = userDropOffaddress;
      print(
          " drop location changed: ${state.userDropOffLocation?.locationName}");
    }
  }
}

final tripStateNotifierProvider =
    StateNotifierProvider<TripStateNotifier, TripViewModel>(
        (ref) => TripStateNotifier());
