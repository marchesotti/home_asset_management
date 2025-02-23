import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/search_assets_use_case.dart';
import 'package:home_asset_management/modules/assets/presentation/controllers/search_asset_controller.dart';

import 'search_asset_controller_test.mocks.dart';

@GenerateMocks([SearchAssetsUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SearchAssetController searchController;
  late MockSearchAssetsUseCase mockSearchAssetsUseCase;
  setUp(() {
    mockSearchAssetsUseCase = MockSearchAssetsUseCase();

    // Inject mock use case into the dependency injector
    DependencyInjector.instance.injectSingleton<SearchAssetsUseCase>(() => mockSearchAssetsUseCase);

    searchController = SearchAssetController.getInstance();
  });

  tearDown(() {
    searchController.dispose();
    DependencyInjector.instance.resetAll();
  });

  group('SearchAssetController', () {
    test('should initialize with empty values', () {
      expect(searchController.isSearchingNotifier.value, isFalse);
      expect(searchController.assetsNotifier.value, isEmpty);
      expect(searchController.searchController.text, isEmpty);
    });

    group('onChanged', () {
      test('should set isSearching to true immediately when search starts', () {
        when(mockSearchAssetsUseCase.execute('test')).thenAnswer((_) async => Right([]));

        searchController.onChanged('test');

        expect(searchController.isSearchingNotifier.value, isTrue);
      });

      test('should clear assets when query is empty', () async {
        // Setup initial state
        searchController.assetsNotifier.value = [AssetTypeEnum.refrigerator];

        // Trigger empty search
        searchController.onChanged('');

        // Wait for debounce
        await Future.delayed(const Duration(milliseconds: 600));

        expect(searchController.assetsNotifier.value, isEmpty);
        expect(searchController.isSearchingNotifier.value, isFalse);
      });

      test('should update assets on successful search', () async {
        final expectedAssets = [AssetTypeEnum.refrigerator, AssetTypeEnum.airConditioner];

        when(mockSearchAssetsUseCase.execute('test')).thenAnswer((_) async => Right(expectedAssets));

        // Trigger search
        searchController.onChanged('test');

        // Wait for debounce and async operation
        await Future.delayed(const Duration(milliseconds: 600));

        expect(searchController.assetsNotifier.value, equals(expectedAssets));
        expect(searchController.isSearchingNotifier.value, isFalse);
        verify(mockSearchAssetsUseCase.execute('test')).called(1);
      });

      test('should handle failure and clear assets', () async {
        when(mockSearchAssetsUseCase.execute('test')).thenAnswer((_) async => Left(Failure(message: 'Search failed')));

        // Setup initial state with some assets
        searchController.assetsNotifier.value = [AssetTypeEnum.refrigerator];

        // Trigger search
        searchController.onChanged('test');

        // Wait for debounce and async operation
        await Future.delayed(const Duration(milliseconds: 600));

        expect(searchController.assetsNotifier.value, isEmpty);
        expect(searchController.isSearchingNotifier.value, isFalse);
        verify(mockSearchAssetsUseCase.execute('test')).called(1);
      });

      test('should debounce multiple rapid searches', () async {
        final expectedAssets = [AssetTypeEnum.refrigerator];

        when(mockSearchAssetsUseCase.execute('final')).thenAnswer((_) async => Right(expectedAssets));

        // Simulate rapid typing
        searchController.onChanged('t');
        searchController.onChanged('te');
        searchController.onChanged('tes');
        searchController.onChanged('final');

        // Wait for debounce
        await Future.delayed(const Duration(milliseconds: 600));

        verify(mockSearchAssetsUseCase.execute('final')).called(1);
        verifyNever(mockSearchAssetsUseCase.execute('t'));
        verifyNever(mockSearchAssetsUseCase.execute('te'));
        verifyNever(mockSearchAssetsUseCase.execute('tes'));

        expect(searchController.assetsNotifier.value, equals(expectedAssets));
        expect(searchController.isSearchingNotifier.value, isFalse);
      });
    });
  });
}
