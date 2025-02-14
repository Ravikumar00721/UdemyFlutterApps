import 'package:favorite_places/model/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({
    super.key,
    this.location = const PlaceLocation(
      address: "",
      lattitude: 37.422,
      longitide: -122.084,
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<StatefulWidget> createState() {
    return _CreateMapState();
  }
}

class _CreateMapState extends State<MapsScreen> {
  LatLng? pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isSelecting ? "Select Your location" : " Your Location"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: GoogleMap(
          onTap: (location) {
            pickedLocation = location;
          },
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.location.lattitude, widget.location.longitide)),
          markers: (pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                      markerId: const MarkerId('m1'),
                      position: pickedLocation ??
                          LatLng(widget.location.lattitude,
                              widget.location.longitide)),
                }),
    );
  }
}
