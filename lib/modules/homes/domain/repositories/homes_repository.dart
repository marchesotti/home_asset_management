import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

/// A repository for homes.
class HomesRepository implements IHomesRepository {
  late final Box<HomeModel> _homesBox;

  HomesRepository() {
    _homesBox = Hive.box<HomeModel>(HiveBoxes.homes);
  }

  /// Fetches all homes from the database.
  @override
  Future<Response<List<HomeModel>>> getHomes() async {
    try {
      final homes = _homesBox.values.toList();
      return right(homes);
    } catch (e) {
      return left(Failure(message: 'Error fetching homes: ${e.toString()}'));
    }
  }

  /// Creates a home in the database.
  @override
  Future<Response<HomeModel>> createHome({
    required String name,
    required String streetAddress1,
    required String streetAddress2,
    required String city,
    required UsState state,
    required String zip,
  }) async {
    try {
      final address = AddressModel(
        id: DateTime.now().toIso8601String(),
        streetAddress1: streetAddress1,
        streetAddress2: streetAddress2,
        city: city,
        state: state,
        zip: zip,
      );

      final home = HomeModel(id: DateTime.now().toIso8601String(), name: name, address: address);

      await _homesBox.put(home.id, home);
      return right(home);
    } catch (e) {
      return left(Failure(message: 'Error creating home: ${e.toString()}'));
    }
  }

  /// Updates a home in the database.
  @override
  Future<Response<void>> updateHome(HomeModel home) async {
    try {
      await _homesBox.put(home.id, home);
      return right(null);
    } catch (e) {
      return left(Failure(message: 'Error updating home: ${e.toString()}'));
    }
  }

  /// Deletes a home in the database.
  @override
  Future<Response<void>> deleteHome(String id) async {
    try {
      final home = _homesBox.get(id);
      if (home == null) {
        return left(Failure(message: 'Home not found'));
      }

      await _homesBox.delete(id);
      return right(null);
    } catch (e) {
      return left(Failure(message: 'Error deleting home: ${e.toString()}'));
    }
  }
}
