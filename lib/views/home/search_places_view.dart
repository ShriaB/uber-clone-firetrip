import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/global/utils/utils.dart';
import 'package:firetrip/models/location_model.dart';
import 'package:firetrip/services/mapbox_services/search_location.dart';
import 'package:firetrip/provider/trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPlacesView extends ConsumerStatefulWidget {
  const SearchPlacesView({super.key});

  @override
  ConsumerState<SearchPlacesView> createState() => _SearchPlacesViewState();
}

class _SearchPlacesViewState extends ConsumerState<SearchPlacesView> {
  List<LocationModel> predictedPlacesList = [];
  int selectedLocation = -1;
  TextEditingController searchController = TextEditingController();
  bool areLocationsAvailable = false;
  getAddressSuggestions(String address) async {
    setState(() {
      selectedLocation = -1;
    });
    getSearchResultsFromQuery(
            address, ref.read(tripStateNotifierProvider).currentUserLocation)
        .then((suggestions) {
      if (suggestions != null && suggestions.isNotEmpty) {
        setState(() {
          predictedPlacesList = suggestions;
          areLocationsAvailable = true;
        });
      } else {
        setState(() {
          areLocationsAvailable = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {
            if (searchController.text.isEmpty ||
                areLocationsAvailable == false) {
              Utils.showRedSnackBar(context, "Please enter a valid location");
            } else if (selectedLocation == -1) {
              Utils.showRedSnackBar(
                  context, "Please choose a place from the list ");
            } else {
              Navigator.pushNamed(context, RouteNames.reviewRoute);
            }
          },
          backgroundColor: primaryColor,
          child: const Text("Done"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: primaryColor,
              height: 160.0,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                        ),
                        onTap: () {
                          Navigator.pop<LocationModel?>(
                              context,
                              selectedLocation > -1
                                  ? predictedPlacesList[selectedLocation]
                                  : null);
                        },
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          cursorColor: blackColor,
                          onChanged: (value) {
                            if (value.length > 3) {
                              getAddressSuggestions(value);
                            }
                          },
                          style: const TextStyle(
                              color: whiteColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              hintText: "Enter your drop off location",
                              hintStyle: TextStyle(
                                  color: whiteColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: ListView.separated(
                  itemBuilder: (_, index) => ListTile(
                        onTap: () {
                          ref
                              .read(tripStateNotifierProvider.notifier)
                              .updateDropoffLocationAddress(
                                  predictedPlacesList[index]);
                          setState(() {
                            searchController.text =
                                predictedPlacesList[index].locationName ??
                                    "No places found";
                            selectedLocation = index;
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        horizontalTitleGap: -5.0,
                        leading: const Icon(
                          Icons.local_fire_department_rounded,
                          color: primaryColor,
                        ),
                        title: Text(
                          "${predictedPlacesList[index].locationName}",
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 16.0),
                        ),
                        subtitle: Text(
                          "${predictedPlacesList[index].locationAddress}",
                          style: TextStyle(
                              color: Colors.grey[700], fontSize: 12.0),
                        ),
                      ),
                  separatorBuilder: ((_, index) => const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      )),
                  itemCount: predictedPlacesList.length),
            ))
          ],
        ));
  }
}
