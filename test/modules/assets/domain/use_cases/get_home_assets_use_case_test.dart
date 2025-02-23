import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/get_home_assets_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<IAssetsRepository>()])
import 'get_home_assets_use_case_test.mocks.dart';

void main() {
  late GetAssetsUseCase getAssetsUseCase;
  late MockIAssetsRepository mockAssetsRepository;

  setUp(() {
    mockAssetsRepository = MockIAssetsRepository();
    getAssetsUseCase = GetAssetsUseCase(mockAssetsRepository);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  final testAssets = [
    AssetModel(id: 'asset1', type: AssetTypeEnum.refrigerator, homeId: 'test_home_id'),
    AssetModel(id: 'asset2', type: AssetTypeEnum.solarPanel, homeId: 'test_home_id'),
  ];

  group('GetAssetsUseCase', () {
    test('should be a singleton via instance getter', () {
      final mockRepo = MockIAssetsRepository();
      final useCase = GetAssetsUseCase(mockRepo);
      DependencyInjector.instance.injectSingleton<GetAssetsUseCase>(() => useCase);

      final instance1 = GetAssetsUseCase.instance;
      final instance2 = GetAssetsUseCase.instance;

      expect(instance1, isA<GetAssetsUseCase>());
      expect(identical(instance1, instance2), true);
    });

    group('execute', () {
      const testHomeId = 'test_home_id';

      test('should get assets successfully when repository succeeds', () async {
        when(mockAssetsRepository.getHomeAssets(any)).thenAnswer((_) async => right(testAssets));

        final result = await getAssetsUseCase.execute(testHomeId);

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (assets) {
          expect(assets.length, 2);
          expect(assets[0].id, 'asset1');
          expect(assets[0].type, AssetTypeEnum.refrigerator);
          expect(assets[1].id, 'asset2');
          expect(assets[1].type, AssetTypeEnum.solarPanel);
          expect(assets.every((asset) => asset.homeId == testHomeId), true);
        });

        // Verify repository was called with correct parameter
        verify(mockAssetsRepository.getHomeAssets(testHomeId)).called(1);
      });

      test('should return empty list when repository returns empty', () async {
        when(mockAssetsRepository.getHomeAssets(any)).thenAnswer((_) async => right([]));

        final result = await getAssetsUseCase.execute(testHomeId);

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (assets) => expect(assets, isEmpty));
      });

      test('should return failure when repository fails', () async {
        final failure = Failure(message: 'Error fetching assets');
        when(mockAssetsRepository.getHomeAssets(any)).thenAnswer((_) async => left(failure));

        final result = await getAssetsUseCase.execute(testHomeId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'Error fetching assets'),
          (_) => fail('Should return failure'),
        );
      });

      test('should return failure when repository throws exception', () async {
        when(mockAssetsRepository.getHomeAssets(any)).thenThrow(Exception('Unexpected error'));

        final result = await getAssetsUseCase.execute(testHomeId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'Unable to get home assets'),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('dependency injection', () {
      test('should properly inject dependencies', () {
        final mockRepo = MockIAssetsRepository();
        DependencyInjector.instance.injectSingleton<IAssetsRepository>(() => mockRepo);

        final injection = GetAssetsUseCaseInjection();
        injection.inject();

        final injectedUseCase = DependencyInjector.instance.get<GetAssetsUseCase>();
        expect(injectedUseCase, isA<GetAssetsUseCase>());
      });
    });
  });
}
