import 'package:hive/hive.dart';
import 'package:home_asset_management/core/entities/i_model.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';

part 'home_model.g.dart';

/// A model for a home.
@HiveType(typeId: 0)
class HomeModel extends HiveObject implements IModel {
  /// The id of the home.
  @override
  @HiveField(0)
  final String id;

  /// The name of the home.

  @HiveField(1)
  final String name;

  /// The address of the home.
  @HiveField(2)
  final AddressModel address;

  HomeModel({required this.id, required this.name, required this.address});

  /// Copies the home with the given name and address.
  HomeModel copyWith({String? name, AddressModel? address}) {
    return HomeModel(id: id, name: name ?? this.name, address: address ?? this.address);
  }
}
