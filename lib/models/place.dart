import 'package:json_annotation/json_annotation.dart';

// part 'place.g.dart';

@JsonSerializable()

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

@JsonSerializable()

class Place {
  final String id;
  final String title;
  final PlaceLocation location;

  Place({
    required this.id,
    required this.title,
    required this.location,
  });
}

// factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

// Map<String, dynamic> toJson() => _$Place(this);