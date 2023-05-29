import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/global/styles/styles.dart';
import 'package:firetrip/global/utils/time_distance_convertors.dart';
import 'package:firetrip/models/trip_model.dart';
import 'package:firetrip/provider/trip_state.dart';
import 'package:firetrip/services/firebase_services/trips_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RateRideView extends ConsumerStatefulWidget {
  const RateRideView({super.key});

  @override
  ConsumerState<RateRideView> createState() => _RateRideViewState();
}

class _RateRideViewState extends ConsumerState<RateRideView> {
  num rideRating = 0;
  late TripState viewModel;

  @override
  void initState() {
    viewModel = ref.read(tripStateNotifierProvider);
    super.initState();
  }

  /// Create the Trip object
  /// Call Firebase addTrip method to save the trip to Firebase
  /// Get all the trips - Refreshed list
  /// Reset the Tripstate to default so that a new trip can be started by the user
  void saveTrip() async {
    var trip = TripModel(
      source: viewModel.userPickUpLocation,
      destination: viewModel.userDropOffLocation,
      distance: viewModel.distance,
      duration: getTripDuration(viewModel.pickupTime, viewModel.dropOffTime),
      pickup: viewModel.pickupTime,
      dropoff: viewModel.dropOffTime,
      rideRating: rideRating,
    );
    await TripsService.addTrip(trip);
    TripStateNotifier.getTrips();
    ref.read(tripStateNotifierProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 200, 10, 10),
        child: Center(
          child: Column(children: [
            /// Heading text
            const Text(
              "Rate your Ride",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),

            /// Picture of Car
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: Image.asset("assets/images/car.png"),
            ),
            const SizedBox(
              height: 20,
            ),

            /// Car category
            const Text(
              "FireTrip Premium",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),

            /// Rating bar
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                rideRating = rating;
              },
            ),
            const SizedBox(
              height: 20,
            ),

            /// Submit the rating
            /// Calls saveTrip()
            ElevatedButton(
                style: textButtonStyle,
                onPressed: () {
                  saveTrip();
                  Navigator.pushReplacementNamed(context, RouteNames.home);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Text("Submit"),
                )),
          ]),
        ),
      ),
    );
  }
}
