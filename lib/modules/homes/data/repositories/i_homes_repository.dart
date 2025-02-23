import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

/// A repository for homes.
abstract class IHomesRepository {
  /// Fetches all homes from the database.
  Future<Response<List<HomeModel>>> getHomes();
}
