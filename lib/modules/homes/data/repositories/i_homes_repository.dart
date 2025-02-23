import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

/// A repository for homes.
abstract class IHomesRepository {
  /// Fetches all homes from the database.
  Future<Response<List<HomeModel>>> getHomes();

  /// Creates a home in the database.
  Future<Response<HomeModel>> createHome({
    required String name,
    required String streetAddress1,
    required String streetAddress2,
    required String city,
    required UsState state,
    required String zip,
  });

  /// Updates a home in the database.
  Future<Response<void>> updateHome(HomeModel home);
}
