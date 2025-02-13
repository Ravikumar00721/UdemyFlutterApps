import 'package:favorite_places/model/places.dart';
import 'package:flutter/material.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({super.key, required this.places});

  final Place places;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(places.title),
      ),
      body: Stack(
        children: [
          Image.file(
            places.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
