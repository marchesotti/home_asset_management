import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
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
}
