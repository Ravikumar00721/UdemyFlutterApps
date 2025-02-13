import 'package:favorite_places/model/places.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  _PlacesListState createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          "No Places Added Yet",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) => ListTile(
        title: Text(
          widget.places[index].title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
