import 'dart:io';

import 'package:favorite_places/model/places.dart';
import 'package:favorite_places/provider/user_places_provider.dart';
import 'package:favorite_places/widgets/camera_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() {
    return _AddPlacesScreenState();
  }
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {
  final _title_controller = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void savePlace() {
    final enteredText = _title_controller.text;
    if (enteredText.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }
    final l = _selectedLocation?.address;
    print("ADDRESS IN ADD PLACE : $l");
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredText, _selectedImage!, _selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _title_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Places"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: _title_controller,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            SizedBox(
              height: 12,
            ),
            ImageInput(
              onpickImage: (image) {
                _selectedImage = image;
              },
            ),
            SizedBox(
              height: 12,
            ),
            LocationInput(
              onSelectLocatonMap: (location) {
                print(
                    "Location received in AddPlacesScreen: ${location.address}");
                setState(() {
                  _selectedLocation = location;
                });
              },
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: savePlace,
                label: const Text("Add place"))
          ],
        ),
      ),
    );
  }
}
