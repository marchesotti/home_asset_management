import 'package:hive/hive.dart';

part 'asset_type_enum.g.dart';

/// An enum for the type of asset.
@HiveType(typeId: 4)
enum AssetTypeEnum {
  /// The Refrigerator asset.
  @HiveField(0)
  refrigerator,

  /// The Air Conditioner asset.
  @HiveField(1)
  airConditioner,

  /// The HVAC System asset.
  @HiveField(2)
  hvacSystem,

  /// The Solar Panel asset.
  @HiveField(3)
  solarPanel,

  /// The EV Charger asset.
  @HiveField(4)
  evCharger,

  /// The Battery asset.
  @HiveField(5)
  battery,
}
