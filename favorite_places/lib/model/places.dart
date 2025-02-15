import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation(
      {required this.address,
      required this.lattitude,
      required this.longitide});

  final double lattitude;
  final double longitide;
  final String address;
}

class Place {
  Place({
    required this.title,
    required this.image,
    required this.loacation,
    id,
  }) : id = id ?? uuid.v4();

  final id;
  final title;
  File image;
  final PlaceLocation loacation;
}
