import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/create_home_asset_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<IAssetsRepository>()])
import 'create_home_asset_use_case_test.mocks.dart';

void main() {
  late CreateHomeAssetUseCase createHomeAssetUseCase;
  late MockIAssetsRepository mockAssetsRepository;

  setUp(() {
    mockAssetsRepository = MockIAssetsRepository();
    createHomeAssetUseCase = CreateHomeAssetUseCase(mockAssetsRepository);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  final testAsset = AssetModel(id: 'test_id', type: AssetTypeEnum.refrigerator, homeId: 'test_home_id');

  group('CreateHomeAssetUseCase', () {
    test('should be a singleton via instance getter', () {
      final mockRepo = MockIAssetsRepository();
      final useCase = CreateHomeAssetUseCase(mockRepo);
      DependencyInjector.instance.injectSingleton<CreateHomeAssetUseCase>(() => useCase);

      final instance1 = CreateHomeAssetUseCase.instance;
      final instance2 = CreateHomeAssetUseCase.instance;

      expect(instance1, isA<CreateHomeAssetUseCase>());
      expect(identical(instance1, instance2), true);
    });

    group('dependency injection', () {
      test('should properly inject dependencies', () {
        final mockRepo = MockIAssetsRepository();
        DependencyInjector.instance.injectSingleton<IAssetsRepository>(() => mockRepo);

        final injection = CreateHomeAssetUseCaseInjection();
        injection.inject();

        final injectedUseCase = DependencyInjector.instance.get<CreateHomeAssetUseCase>();
        expect(injectedUseCase, isA<CreateHomeAssetUseCase>());
      });
    });

    group('execute', () {
      test('should create asset successfully when repository succeeds', () async {
        when(
          mockAssetsRepository.createHomeAsset(
            homeId: anyNamed('homeId'),
            name: anyNamed('name'),
            type: anyNamed('type'),
          ),
        ).thenAnswer((_) async => right(testAsset));

        final result = await createHomeAssetUseCase.execute('test_home_id', AssetTypeEnum.refrigerator);

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (asset) {
          expect(asset.id, testAsset.id);
          expect(asset.type, testAsset.type);
          expect(asset.homeId, testAsset.homeId);
        });

        // Verify repository was called with correct parameters
        verify(
          mockAssetsRepository.createHomeAsset(
            homeId: 'test_home_id',
            name: AssetTypeEnum.refrigerator.name,
            type: AssetTypeEnum.refrigerator,
          ),
        ).called(1);
      });

      test('should return failure when repository fails', () async {
        final failure = Failure(message: 'Error creating asset');
        when(
          mockAssetsRepository.createHomeAsset(
            homeId: anyNamed('homeId'),
            name: anyNamed('name'),
            type: anyNamed('type'),
          ),
        ).thenAnswer((_) async => left(failure));

        final result = await createHomeAssetUseCase.execute('test_home_id', AssetTypeEnum.refrigerator);

        expect(result.isLeft(), true);
        result.fold((failure) => expect(failure.message, 'Error creating asset'), (_) => fail('Should return failure'));
      });

      test('should return failure when repository throws exception', () async {
        when(
          mockAssetsRepository.createHomeAsset(
            homeId: anyNamed('homeId'),
            name: anyNamed('name'),
            type: anyNamed('type'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        final result = await createHomeAssetUseCase.execute('test_home_id', AssetTypeEnum.refrigerator);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'Unable to create home asset'),
          (_) => fail('Should return failure'),
        );
      });

      test('should use asset type name as asset name', () async {
        when(
          mockAssetsRepository.createHomeAsset(
            homeId: anyNamed('homeId'),
            name: anyNamed('name'),
            type: anyNamed('type'),
          ),
        ).thenAnswer((_) async => right(testAsset));

        await createHomeAssetUseCase.execute('test_home_id', AssetTypeEnum.refrigerator);

        // Verify repository was called with asset type name
        verify(
          mockAssetsRepository.createHomeAsset(
            homeId: anyNamed('homeId'),
            name: AssetTypeEnum.refrigerator.name,
            type: anyNamed('type'),
          ),
        ).called(1);
      });

      test('should handle different asset types correctly', () async {
        final solarPanelAsset = AssetModel(id: 'test_id_2', type: AssetTypeEnum.solarPanel, homeId: 'test_home_id');

        when(
          mockAssetsRepository.createHomeAsset(
            homeId: anyNamed('homeId'),
            name: anyNamed('name'),
            type: anyNamed('type'),
          ),
        ).thenAnswer((_) async => right(solarPanelAsset));

        final result = await createHomeAssetUseCase.execute('test_home_id', AssetTypeEnum.solarPanel);

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (asset) {
          expect(asset.type, AssetTypeEnum.solarPanel);
        });
      });
    });
  });
}
