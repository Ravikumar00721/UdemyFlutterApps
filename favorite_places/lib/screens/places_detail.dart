import 'package:favorite_places/model/places.dart';
import 'package:favorite_places/screens/maps.dart';
import 'package:flutter/material.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({super.key, required this.places});

  final Place places;

  String get locationImage {
    final lat = places.loacation.lattitude;
    final long = places.loacation.longitide;

    // Print the coordinates for debugging
    print("Latitude: $lat, Longitude: $long");

    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$long=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyCwdeYzq24mb3UIg85UQDZaivSbFZMla2M';
  }

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
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => MapsScreen(
                                location: places.loacation,
                                isSelecting: false,
                              )));
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationImage),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Text(
                      places.loacation.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
