import 'package:firetrip/common/constants/colors.dart';
import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:firetrip/feature_home/services/search_location.dart';
import 'package:firetrip/feature_trip/view_models/trip_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
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

  getAddressSuggestions(String address) async {
    print("predict called");
    getSearchResultsFromQuery(
            address, ref.read(tripStateNotifierProvider).currentUserLocation)
        .then((suggestions) {
      print(suggestions);
      if (suggestions != null) {
        setState(() {
          predictedPlacesList = suggestions;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ListView.separated(
              itemBuilder: (_, index) => InkWell(
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "${predictedPlacesList[index].locationAddress}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                    ),
                  )),
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
