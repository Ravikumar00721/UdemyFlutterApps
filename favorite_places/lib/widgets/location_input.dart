import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Location? _pickedLocation;
  var isGettingLocation = false;

  void getCurrentLocation() async {
    Location location = Location();

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

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final long = locationData.longitude;

    final url = Uri.https(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyC95dAOFb3A5VRlnREpXccfJo9r4j5K-fs');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location Choosen",
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: Theme.of(context).primaryColor.withOpacity(0.2))),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                icon: const Icon(Icons.location_on),
                onPressed: getCurrentLocation,
                label: const Text("Get Current Location")),
            TextButton.icon(
                icon: const Icon(Icons.map),
                onPressed: () {},
                label: const Text("Select On Map")),
          ],
        )
      ],
    );
  }
}
