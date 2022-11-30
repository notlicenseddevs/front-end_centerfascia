

class Place {
  final String description;
  final String placeId;

  Place({required this.description, required this.placeId});

  Place.fromJson(Map<String, dynamic> json)
      : this.description = json['description'],
        this.placeId = json['place_id'];

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'placeId': this.placeId,
    };
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final String name;
  final double rating;
  final String vicinity;
  final String website;
  final double lat;
  final double lng;

  PlaceDetail({
    required this.placeId,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.name,
    required this.rating,
    required this.vicinity,
    this.website = '',
    required this.lat,
    required this.lng,
  });

  PlaceDetail.fromJson(Map<String, dynamic> json)
      : this.placeId = json['place_id'],
        this.formattedAddress = json['formatted_address'],
        this.formattedPhoneNumber = json['formatted_phone_number'],
        this.name = json['name'],
        this.rating = json['rating'].toDouble(),
        this.vicinity = json['vicinity'],
        this.website = json['website'] ?? '',
        this.lat = json['geometry']['location']['lat'],
        this.lng = json['geometry']['location']['lng'];

  Map<String, dynamic> toMap() {
    return {
      'placeId': this.placeId,
      'formateedAddress': this.formattedAddress,
      'formateedPhoneNumber': this.formattedPhoneNumber,
      'name': this.name,
      'rating': this.rating,
      'vicinity': this.vicinity,
      'website': this.website,
      'lat': this.lat,
      'lng': this.lng,
    };
  }
}