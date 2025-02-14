import 'dart:convert';

import 'package:favorite_places/model/places.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocatonMap});

  final void Function(PlaceLocation location) onSelectLocatonMap;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.lattitude;
    final long = _pickedLocation!.longitide;

    // Print the coordinates for debugging
    print("Latitude: $lat, Longitude: $long");

    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$long=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyCwdeYzq24mb3UIg85UQDZaivSbFZMla2M';
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location service is disabled.");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission denied.");
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null || long == null) {
      print("Failed to get location.");
      return;
    }

    print("Retrieved location: Latitude=$lat, Longitude=$long");

    // Correct Google Geocoding API URL
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyCwdeYzq24mb3UIg85UQDZaivSbFZMla2M');

    try {
      final response = await http.get(url);
      final resData = json.decode(response.body);

      if (resData['results'].isEmpty) {
        print("No address found for this location.");
        return;
      }

      final address = resData['results'][0]['formatted_address'];
      print("Formatted Address: $address");

      setState(() {
        _pickedLocation =
            PlaceLocation(address: address, lattitude: lat, longitide: long);
        isGettingLocation = false;
      });
    } catch (error) {
      print("Error fetching address: $error");
      setState(() {
        isGettingLocation = false;
      });
    }

    widget.onSelectLocatonMap(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading map image: $error");
          return const Text("Failed to load map image");
        },
      );
    }

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
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              onPressed: getCurrentLocation,
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              onPressed: () {},
              label: const Text("Select On Map"),
            ),
          ],
        ),
      ],
    );
  }
}
