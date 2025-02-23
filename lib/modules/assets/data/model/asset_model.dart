import 'package:hive/hive.dart';
import 'package:home_asset_management/core/entities/i_model.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';

part 'asset_model.g.dart';

/// A model for an asset.
@HiveType(typeId: 3)
class AssetModel extends HiveObject implements IModel {
  /// The id of the asset.
  @override
  @HiveField(0)
  final String id;

  /// The type of the asset.
  @HiveField(2)
  final AssetTypeEnum type;

  /// The id of the home that the asset belongs to.
  @HiveField(3)
  final String homeId;

  AssetModel({required this.id, required this.type, required this.homeId});
}
