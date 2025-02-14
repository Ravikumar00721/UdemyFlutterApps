import 'package:favorite_places/model/places.dart';
import 'package:favorite_places/screens/places_detail.dart';
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
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(widget.places[index].image),
        ),
        title: Text(
          widget.places[index].title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        subtitle: Text(
          widget.places[index].loacation.address,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) =>
                  PlacesDetailScreen(places: widget.places[index])));
        },
      ),
    );
  }
}
