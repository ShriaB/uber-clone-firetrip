import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/provider/trip_state.dart';
import 'package:firetrip/widgets/trip_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllTripsView extends ConsumerStatefulWidget {
  const AllTripsView({super.key});

  @override
  ConsumerState<AllTripsView> createState() => _AllTripsViewState();
}

class _AllTripsViewState extends ConsumerState<AllTripsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: primaryColor,
        title: const Text("Your Trips"),
      ),
      body: ListView.builder(
          itemCount: TripState.tripCount,
          itemBuilder: (_, index) =>
              TripCardWidget(trip: TripState.allTripInfoList[index])),
    );
  }
}
