// class Address {
//   final String street;
//   final String city;
//   final String state;
//   final String zipCode;
//   final String country;
//   //final bool canStoreKeys;
//
//   Address({
//     required this.street,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.country,
//    // required this.canStoreKeys,
//   });
//
//   // Convert Address object to JSON
//   Map<String, dynamic> toJson() => {
//     'street': street,
//     'city': city,
//     'state': state,
//     'zipCode': zipCode,
//     'country': country,
//   };
//
//   // Create Address object from JSON
//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       street: json['street'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       zipCode: json['zipCode'] ?? '',
//       country: json['country'] ?? '',
//       //canStoreKeys: json['canStoreKeys'] ?? false,
//     );
//   }
// }
//
// class Location {
//   final String id;
//   final String name;
//   final String description;
//   final double regularPrice;
//   final String priceCurrency;
//   final Address address;
//   final List<String> pictures;
//   final int capacity;
//   final bool overbooking;
//
//   Location({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.regularPrice,
//     required this.priceCurrency,
//     required this.address,
//     required this.pictures,
//     required this.capacity,
//     required this.overbooking,
//   });
//
//   // Convert Location object to JSON
//   Map<String, dynamic> toJson() => {
//     '_id': id,
//     'name': name,
//     'description': description,
//     'regularPrice': regularPrice,
//     'priceCurrency': priceCurrency,
//     'address': address.toJson(),
//     'pictures': pictures,
//     'capacity': capacity,
//     'overbooking': overbooking,
//   };
//
//   // Create Location object from JSON
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       regularPrice: json['regularPrice']?.toDouble() ?? 0.0,
//       priceCurrency: json['priceCurrency'] ?? '',
//       address: Address.fromJson(json['address'] ?? {}),
//       pictures: List<String>.from(json['pictures'] ?? []),
//       capacity: json['capacity'] ?? 0,
//       overbooking: json['overbooking'] ?? false,
//     );
//   }
// }

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
  };

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class Location {
  final String id;
  final String name;
  final String description;
  final double regularPrice;
  final String priceCurrency;
  final Address address;
  final List<String> pictures;
  final int capacity;
  final bool overbooking;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.priceCurrency,
    required this.address,
    required this.pictures,
    required this.capacity,
    required this.overbooking,
  });

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'description': description,
    'regularPrice': regularPrice,
    'priceCurrency': priceCurrency,
    'address': address.toJson(),
    'pictures': pictures,
    'capacity': capacity,
    'overbooking': overbooking,
  };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      regularPrice: json['regularPrice']?.toDouble() ?? 0.0,
      priceCurrency: json['priceCurrency'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      pictures: List<String>.from(json['pictures'] ?? []),
      capacity: json['capacity'] ?? 0,
      overbooking: json['overbooking'] ?? false,
    );
  }
}