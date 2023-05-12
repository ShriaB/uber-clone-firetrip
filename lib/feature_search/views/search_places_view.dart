import 'package:firetrip/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class SearchPlacesView extends StatefulWidget {
  const SearchPlacesView({super.key});

  @override
  State<SearchPlacesView> createState() => _SearchPlacesViewState();
}

class _SearchPlacesViewState extends State<SearchPlacesView> {
  List<SearchInfo> predictedPlacesList = [];

  getAddressSuggestions(String address) async {
    if (address.length > 4) {
      print("predict called");
      predictedPlacesList = await addressSuggestion(address);
      print(predictedPlacesList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextField(
                      cursorColor: blackColor,
                      onChanged: (value) {
                        print("input changed");
                        getAddressSuggestions(value);
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
          padding: const EdgeInsets.all(20.0),
          child: ListView.separated(
              itemBuilder: (_, index) => TextButton(
                  onPressed: () {},
                  child: Text(
                    "${predictedPlacesList[index].address}",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
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
