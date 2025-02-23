import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';

/// A repository for assets.
class AssetsRepository implements IAssetsRepository {
  late final Box<AssetModel> _assetsBox;

  AssetsRepository() {
    _assetsBox = Hive.box<AssetModel>(HiveBoxes.assets);
  }

  /// Fetches all assets from the database.
  @override
  Future<Response<List<AssetModel>>> getHomeAssets(String homeId) async {
    try {
      final assets = _assetsBox.values.where((asset) => asset.homeId == homeId).toList();
      return right(assets);
    } catch (e) {
      return left(Failure(message: 'Error fetching assets: ${e.toString()}'));
    }
  }

  /// Creates a home asset in the database.
  @override
  Future<Response<AssetModel>> createHomeAsset({
    required String homeId,
    required String name,
    required AssetTypeEnum type,
  }) async {
    try {
      final asset = AssetModel(id: DateTime.now().toIso8601String(), type: type, homeId: homeId);

      await _assetsBox.put(asset.id, asset);
      return right(asset);
    } catch (e) {
      return left(Failure(message: 'Error creating asset: ${e.toString()}'));
    }
  }

  /// Deletes a home asset from the database.
  @override
  Future<Response<void>> deleteHomeAsset(String assetId) async {
    try {
      await _assetsBox.delete(assetId);
      return right(null);
    } catch (e) {
      return left(Failure(message: 'Error deleting asset: ${e.toString()}'));
    }
  }
}
