import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

/// Initializes Hive for unit tests using a temporary directory.
Future<void> initializeHiveForTests() async {
  // Use a temporary directory for Hive in tests (avoids plugin issues)
  final testDir = Directory.systemTemp.createTempSync();
  Hive.init(testDir.path);

  // Register adapters
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(HomeModelAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(AddressModelAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(UsStateAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(AssetModelAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(AssetTypeEnumAdapter());
}

/// Close hive boxes and delete from disk.
Future<void> clearHiveForTests() async {
  await Hive.close();
  await Hive.deleteFromDisk();
}
