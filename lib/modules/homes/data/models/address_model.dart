import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/entities/i_model.dart';

part 'address_model.g.dart';

/// A model for an address.
@HiveType(typeId: 1)
class AddressModel extends HiveObject implements IModel {
  /// The id of the address.
  @override
  @HiveField(0)
  final String id;

  /// The street address 1 of the address.
  @HiveField(1)
  final String streetAddress1;

  /// The street address 2 of the address.
  @HiveField(2)
  final String streetAddress2;

  /// The city of the address.
  @HiveField(3)
  final String city;

  /// The state of the address.
  @HiveField(4)
  final UsState state;

  /// The zip code of the address.
  @HiveField(5)
  final String zip;

  AddressModel({
    required this.id,
    required this.streetAddress1,
    required this.streetAddress2,
    required this.city,
    required this.state,
    required this.zip,
  });

  /// Copies the address with the given street address 1, street address 2, city, state, and zip code.
  AddressModel copyWith({String? streetAddress1, String? streetAddress2, String? city, UsState? state, String? zip}) {
    return AddressModel(
      id: id,
      streetAddress1: streetAddress1 ?? this.streetAddress1,
      streetAddress2: streetAddress2 ?? this.streetAddress2,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
    );
  }

  /// Returns a string representation of the address.
  @override
  String toString() {
    String address = streetAddress1;
    if (streetAddress2.isNotEmpty) {
      address += ', $streetAddress2';
    }
    address += ', $city, ${state.name}, $zip';
    return address;
  }
}
