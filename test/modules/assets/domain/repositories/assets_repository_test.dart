import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/domain/repositories/assets_repository.dart';

import '../../../../config/hive.dart';

void main() {
  late AssetsRepository assetsRepository;
  late Box<AssetModel> assetsBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await initializeHiveForTests();

    assetsBox = await Hive.openBox<AssetModel>(HiveBoxes.assets);
    assetsRepository = AssetsRepository();
  });

  tearDown(() async {
    await clearHiveForTests();
  });

  group('getHomeAssets', () {
    test('should return empty list when no assets exist', () async {
      final result = await assetsRepository.getHomeAssets('home_id');

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('should return only assets for specified home', () async {
      // Create test data for target home
      final targetHomeAsset1 = AssetModel(id: 'asset1', type: AssetTypeEnum.refrigerator, homeId: 'target_home');
      final targetHomeAsset2 = AssetModel(id: 'asset2', type: AssetTypeEnum.hvacSystem, homeId: 'target_home');

      // Create test data for different home
      final otherHomeAsset = AssetModel(id: 'asset3', type: AssetTypeEnum.airConditioner, homeId: 'other_home');

      // Add all test data to box
      await assetsBox.putAll({
        targetHomeAsset1.id: targetHomeAsset1,
        targetHomeAsset2.id: targetHomeAsset2,
        otherHomeAsset.id: otherHomeAsset,
      });

      final result = await assetsRepository.getHomeAssets('target_home');

      expect(result.isRight(), true);
      final assets = result.getOrElse(() => []);
      expect(assets.length, 2);
      expect(assets.every((asset) => asset.homeId == 'target_home'), true);
      expect(assets.map((asset) => asset.id).toSet(), {'asset1', 'asset2'});
    });

    test('should handle box access error', () async {
      // Force box to be closed to simulate error
      await assetsBox.close();

      final result = await assetsRepository.getHomeAssets('home_id');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message.contains('Error fetching assets'), true),
        (_) => fail('Should return failure'),
      );
    });

    test('should handle corrupted data gracefully', () async {
      // Create an asset with missing required data
      final corruptedAsset = AssetModel(
        id: 'corrupted',
        type: AssetTypeEnum.refrigerator,
        homeId: '', // Invalid empty homeId
      );

      await assetsBox.put('corrupted', corruptedAsset);

      final result = await assetsRepository.getHomeAssets('home_id');

      expect(result.isRight(), true); // Should handle invalid data gracefully
      final assets = result.getOrElse(() => []);
      expect(assets, isEmpty); // Corrupted asset should be filtered out
    });

    test('should filter assets by home ID correctly', () async {
      final targetHomeAsset = AssetModel(id: 'asset1', type: AssetTypeEnum.refrigerator, homeId: 'target_home');

      final otherHomeAsset = AssetModel(id: 'asset2', type: AssetTypeEnum.solarPanel, homeId: 'other_home');

      await assetsBox.putAll({targetHomeAsset.id: targetHomeAsset, otherHomeAsset.id: otherHomeAsset});

      final result = await assetsRepository.getHomeAssets('target_home');

      expect(result.isRight(), true);
      final assets = result.getOrElse(() => []);
      expect(assets.length, 1);
      expect(assets.first.id, 'asset1');
      expect(assets.first.homeId, 'target_home');
    });
  });

  group('createHomeAsset', () {
    test('should create asset successfully', () async {
      final result = await assetsRepository.createHomeAsset(
        homeId: 'test_home',
        name: 'New Asset',
        type: AssetTypeEnum.solarPanel,
      );

      expect(result.isRight(), true);
      final createdAsset = result.getOrElse(() => throw Exception('Failed to get asset'));

      expect(createdAsset.type, AssetTypeEnum.solarPanel);
      expect(createdAsset.homeId, 'test_home');

      // Verify asset was saved to box
      expect(assetsBox.values.length, 1);
      final savedAsset = assetsBox.get(createdAsset.id);
      expect(savedAsset, isNotNull);
      expect(savedAsset?.type, AssetTypeEnum.solarPanel);
      expect(savedAsset?.homeId, 'test_home');
    });

    test('should handle box access error during creation', () async {
      await assetsBox.close();

      final result = await assetsRepository.createHomeAsset(
        homeId: 'test_home',
        name: 'Test Asset',
        type: AssetTypeEnum.refrigerator,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message.contains('Error creating asset'), true),
        (_) => fail('Should return failure'),
      );
    });

    test('should create asset with unique ID', () async {
      final result1 = await assetsRepository.createHomeAsset(
        homeId: 'test_home',
        name: 'Asset 1',
        type: AssetTypeEnum.refrigerator,
      );

      final result2 = await assetsRepository.createHomeAsset(
        homeId: 'test_home',
        name: 'Asset 2',
        type: AssetTypeEnum.solarPanel,
      );

      expect(result1.isRight(), true);
      expect(result2.isRight(), true);

      final asset1 = result1.getOrElse(() => throw Exception('Failed to get asset'));
      final asset2 = result2.getOrElse(() => throw Exception('Failed to get asset'));

      expect(asset1.id, isNot(equals(asset2.id)));
    });
  });

  group('deleteHomeAsset', () {
    late AssetModel asset1;
    late AssetModel asset2;

    setUp(() async {
      // Create test assets
      asset1 = AssetModel(id: 'asset1', type: AssetTypeEnum.refrigerator, homeId: 'test_home');
      asset2 = AssetModel(id: 'asset2', type: AssetTypeEnum.solarPanel, homeId: 'test_home');

      // Clear any existing data and add test assets
      await assetsBox.clear();
      await assetsBox.putAll({asset1.id: asset1, asset2.id: asset2});
    });

    test('should handle box access error during deletion', () async {
      await assetsBox.close();

      final result = await assetsRepository.deleteHomeAsset(asset1.id);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message.contains('Error deleting asset'), true),
        (_) => fail('Should return failure'),
      );
    });

    test('should handle deletion of non-existent asset', () async {
      final result = await assetsRepository.deleteHomeAsset('non_existent_id');

      expect(result.isRight(), true); // Deleting non-existent asset should be treated as success
    });

    test('should delete asset and maintain box integrity', () async {
      expect(assetsBox.values.length, 2, reason: 'Should start with 2 assets');

      // Delete one asset
      final result = await assetsRepository.deleteHomeAsset(asset1.id);

      expect(result.isRight(), true);
      expect(assetsBox.get(asset1.id), isNull, reason: 'Deleted asset should not exist');
      expect(assetsBox.get(asset2.id), isNotNull, reason: 'Other asset should remain');
      expect(assetsBox.values.length, 1, reason: 'Should have 1 asset remaining');
    });
  });
}
