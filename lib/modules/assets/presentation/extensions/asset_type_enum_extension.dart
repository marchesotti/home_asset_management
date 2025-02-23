import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';

/// An extension on the [AssetTypeEnum] class.
extension AssetTypeEnumExtension on AssetTypeEnum {
  /// The icon for the asset type.
  IconData get icon {
    switch (this) {
      case AssetTypeEnum.refrigerator:
        return Icons.kitchen;
      case AssetTypeEnum.airConditioner:
        return Icons.air;
      case AssetTypeEnum.hvacSystem:
        return Icons.thermostat;
      case AssetTypeEnum.solarPanel:
        return Icons.solar_power;
      case AssetTypeEnum.evCharger:
        return Icons.electric_car;
      case AssetTypeEnum.battery:
        return Icons.battery_charging_full;
    }
  }

  /// The title for the asset type.
  String get title {
    switch (this) {
      case AssetTypeEnum.refrigerator:
        return 'Refrigerator';
      case AssetTypeEnum.airConditioner:
        return 'Air Conditioner';
      case AssetTypeEnum.hvacSystem:
        return 'HVAC System';
      case AssetTypeEnum.solarPanel:
        return 'Solar Panel';
      case AssetTypeEnum.evCharger:
        return 'EV Charger';
      case AssetTypeEnum.battery:
        return 'Battery';
    }
  }
}
