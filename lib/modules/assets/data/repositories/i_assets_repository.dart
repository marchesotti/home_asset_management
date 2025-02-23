import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';

/// A repository for assets.
abstract class IAssetsRepository {
  /// Fetches all assets from the database.
  Future<Response<List<AssetModel>>> getHomeAssets(String homeId);

  /// Creates a home asset in the database.
  Future<Response<AssetModel>> createHomeAsset({
    required String homeId,
    required String name,
    required AssetTypeEnum type,
  });

  /// Deletes a home asset from the database.
  Future<Response<void>> deleteHomeAsset(String assetId);
}
