import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

import 'package:path_provider/path_provider.dart';

/// Initializes Hive and registers adapters.
///
/// This function initializes Hive with the application's document directory
/// if running on non-web platforms. If running on web, it initializes Hive
/// without a path.
Future<void> initializeHive() async {
  final documentDirectory = kIsWeb ? null : await getApplicationDocumentsDirectory();

  // Initialize Hive
  Hive.init(documentDirectory?.path);

  // Register adapters
  Hive.registerAdapter(HomeModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());
  Hive.registerAdapter(UsStateAdapter());

  // Open boxes
  await Hive.openBox<HomeModel>(HiveBoxes.homes);
}
