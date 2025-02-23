import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/presentation/extensions/asset_type_enum_extension.dart';

void main() {
  group('AssetTypeEnumExtension', () {
    group('icon getter', () {
      test('should return correct icon for refrigerator', () {
        expect(AssetTypeEnum.refrigerator.icon, equals(Icons.kitchen));
      });

      test('should return correct icon for air conditioner', () {
        expect(AssetTypeEnum.airConditioner.icon, equals(Icons.air));
      });

      test('should return correct icon for HVAC system', () {
        expect(AssetTypeEnum.hvacSystem.icon, equals(Icons.thermostat));
      });

      test('should return correct icon for solar panel', () {
        expect(AssetTypeEnum.solarPanel.icon, equals(Icons.solar_power));
      });

      test('should return correct icon for EV charger', () {
        expect(AssetTypeEnum.evCharger.icon, equals(Icons.electric_car));
      });

      test('should return correct icon for battery', () {
        expect(AssetTypeEnum.battery.icon, equals(Icons.battery_charging_full));
      });
    });

    group('title getter', () {
      test('should return correct title for refrigerator', () {
        expect(AssetTypeEnum.refrigerator.title, equals('Refrigerator'));
      });

      test('should return correct title for air conditioner', () {
        expect(AssetTypeEnum.airConditioner.title, equals('Air Conditioner'));
      });

      test('should return correct title for HVAC system', () {
        expect(AssetTypeEnum.hvacSystem.title, equals('HVAC System'));
      });

      test('should return correct title for solar panel', () {
        expect(AssetTypeEnum.solarPanel.title, equals('Solar Panel'));
      });

      test('should return correct title for EV charger', () {
        expect(AssetTypeEnum.evCharger.title, equals('EV Charger'));
      });

      test('should return correct title for battery', () {
        expect(AssetTypeEnum.battery.title, equals('Battery'));
      });
    });
  });
}
