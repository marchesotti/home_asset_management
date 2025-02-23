import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/core/helpers/hive.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

import '../../config/hive.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return '.';
      },
    );

    await initializeHive();
  });

  tearDown(() async {
    await clearHiveForTests();
  });

  test('should initialize Hive and register all adapters', () async {
    // Verify all adapters are registered
    expect(Hive.isAdapterRegistered(0), isTrue); // HomeModelAdapter
    expect(Hive.isAdapterRegistered(1), isTrue); // AddressModelAdapter
    expect(Hive.isAdapterRegistered(2), isTrue); // UsStateAdapter
    expect(Hive.isAdapterRegistered(3), isTrue); // AssetModelAdapter
    expect(Hive.isAdapterRegistered(4), isTrue); // AssetTypeEnumAdapter

    // Verify all boxes are opened
    expect(Hive.box<HomeModel>(HiveBoxes.homes).isOpen, isTrue);
    expect(Hive.box<AssetModel>(HiveBoxes.assets).isOpen, isTrue);
  });
}
