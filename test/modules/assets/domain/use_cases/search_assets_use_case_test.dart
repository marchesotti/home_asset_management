import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/search_assets_use_case.dart';
import 'package:home_asset_management/modules/assets/presentation/extensions/asset_type_enum_extension.dart';

void main() {
  late SearchAssetsUseCase searchAssetsUseCase;

  setUp(() {
    searchAssetsUseCase = SearchAssetsUseCase();
  });

  group('SearchAssetsUseCase', () {
    test('should return matching assets when searching by enum name', () async {
      const query = 'air';

      final result = await searchAssetsUseCase.execute(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (assets) {
        expect(assets.isNotEmpty, true);
        expect(assets.contains(AssetTypeEnum.airConditioner), true);
        expect(
          assets.every(
            (asset) =>
                asset.name.toLowerCase().contains(query.toLowerCase()) ||
                asset.title.toLowerCase().contains(query.toLowerCase()),
          ),
          true,
        );
      });
    });

    test('should return matching assets when searching by display title', () async {
      const query = 'Air';

      final result = await searchAssetsUseCase.execute(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (assets) {
        expect(assets.isNotEmpty, true);
        expect(assets.contains(AssetTypeEnum.airConditioner), true);
        expect(
          assets.every(
            (asset) =>
                asset.name.toLowerCase().contains(query.toLowerCase()) ||
                asset.title.toLowerCase().contains(query.toLowerCase()),
          ),
          true,
        );
      });
    });

    test('should return empty list when no matches found', () async {
      const query = 'nonexistentasset123456789';

      final result = await searchAssetsUseCase.execute(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (assets) {
        expect(assets.isEmpty, true);
      });
    });

    test('should be case insensitive', () async {
      const query = 'aIr';

      final result = await searchAssetsUseCase.execute(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (assets) {
        expect(assets.isNotEmpty, true);
        expect(assets.contains(AssetTypeEnum.airConditioner), true);
        expect(
          assets.every(
            (asset) =>
                asset.name.toLowerCase().contains(query.toLowerCase()) ||
                asset.title.toLowerCase().contains(query.toLowerCase()),
          ),
          true,
        );
      });
    });

    test('should handle empty query string', () async {
      const query = '';

      final result = await searchAssetsUseCase.execute(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (assets) {
        expect(assets.isNotEmpty, true);
        expect(assets, AssetTypeEnum.values);
      });
    });

    test('should handle whitespace query string', () async {
      const query = '   ';

      final result = await searchAssetsUseCase.execute(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (assets) {
        expect(assets.isEmpty, true);
      });
    });

    test('should match multiple assets when query is common', () async {
      const query = 'er'; // Should match refrigerator, airConditioner, evCharger

      final result = await searchAssetsUseCase.execute(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (assets) {
        expect(assets.length, greaterThan(1));
        expect(assets.contains(AssetTypeEnum.refrigerator), true);
        expect(assets.contains(AssetTypeEnum.airConditioner), true);
        expect(assets.contains(AssetTypeEnum.evCharger), true);
      });
    });
  });
}
