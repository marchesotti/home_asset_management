import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/delete_home_assets_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<IAssetsRepository>()])
import 'delete_home_assets_use_case_test.mocks.dart';

void main() {
  late DeleteHomeAssetUseCase deleteHomeAssetUseCase;
  late MockIAssetsRepository mockAssetsRepository;

  setUp(() {
    mockAssetsRepository = MockIAssetsRepository();
    deleteHomeAssetUseCase = DeleteHomeAssetUseCase(mockAssetsRepository);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  group('DeleteHomeAssetUseCase', () {
    test('should be a singleton via instance getter', () {
      final mockRepo = MockIAssetsRepository();
      final useCase = DeleteHomeAssetUseCase(mockRepo);
      DependencyInjector.instance.injectSingleton<DeleteHomeAssetUseCase>(() => useCase);

      final instance1 = DeleteHomeAssetUseCase.instance;
      final instance2 = DeleteHomeAssetUseCase.instance;

      expect(instance1, isA<DeleteHomeAssetUseCase>());
      expect(identical(instance1, instance2), true);
    });

    group('execute', () {
      const testAssetId = 'test_asset_id';

      test('should delete asset successfully when repository succeeds', () async {
        when(mockAssetsRepository.deleteHomeAsset(any)).thenAnswer((_) async => right(null));

        final result = await deleteHomeAssetUseCase.execute(testAssetId);

        expect(result.isRight(), true);

        // Verify repository was called with correct parameter
        verify(mockAssetsRepository.deleteHomeAsset(testAssetId)).called(1);
      });

      test('should return failure when repository fails', () async {
        final failure = Failure(message: 'Error deleting asset');
        when(mockAssetsRepository.deleteHomeAsset(any)).thenAnswer((_) async => left(failure));

        final result = await deleteHomeAssetUseCase.execute(testAssetId);

        expect(result.isLeft(), true);
        result.fold((failure) => expect(failure.message, 'Error deleting asset'), (_) => fail('Should return failure'));
      });

      test('should return failure when repository throws exception', () async {
        when(mockAssetsRepository.deleteHomeAsset(any)).thenThrow(Exception('Unexpected error'));

        final result = await deleteHomeAssetUseCase.execute(testAssetId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'Unable to delete home asset'),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('dependency injection', () {
      test('should properly inject dependencies', () {
        final mockRepo = MockIAssetsRepository();
        DependencyInjector.instance.injectSingleton<IAssetsRepository>(() => mockRepo);

        final injection = DeleteHomeAssetUseCaseInjection();
        injection.inject();

        final injectedUseCase = DependencyInjector.instance.get<DeleteHomeAssetUseCase>();
        expect(injectedUseCase, isA<DeleteHomeAssetUseCase>());
      });
    });
  });
}
