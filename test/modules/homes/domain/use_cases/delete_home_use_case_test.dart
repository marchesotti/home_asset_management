import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/delete_home_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<IHomesRepository>(), MockSpec<IAssetsRepository>()])
import 'delete_home_use_case_test.mocks.dart';

void main() {
  late DeleteHomeUseCase deleteHomeUseCase;
  late MockIHomesRepository mockHomesRepository;
  late MockIAssetsRepository mockAssetsRepository;

  setUp(() {
    mockHomesRepository = MockIHomesRepository();
    mockAssetsRepository = MockIAssetsRepository();
    deleteHomeUseCase = DeleteHomeUseCase(mockHomesRepository, mockAssetsRepository);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  group('DeleteHomeUseCase', () {
    test('should be a singleton via instance getter', () {
      final homesRepository = MockIHomesRepository();
      final assetsRepository = MockIAssetsRepository();
      final useCase = DeleteHomeUseCase(homesRepository, assetsRepository);
      DependencyInjector.instance.injectSingleton<DeleteHomeUseCase>(() => useCase);

      final instance1 = DeleteHomeUseCase.instance;
      final instance2 = DeleteHomeUseCase.instance;

      expect(instance1, isA<DeleteHomeUseCase>());
      expect(identical(instance1, instance2), true);
    });

    group('execute', () {
      const testHomeId = 'test_home_id';

      test('should delete home successfully when repository succeeds', () async {
        when(mockHomesRepository.deleteHome(any)).thenAnswer((_) async => right(null));
        when(mockAssetsRepository.getHomeAssets(any)).thenAnswer((_) async => right([]));

        final result = await deleteHomeUseCase.execute(testHomeId);

        expect(result.isRight(), true);

        // Verify repository was called with correct parameter
        verify(mockHomesRepository.deleteHome(testHomeId)).called(1);
      });

      test('should return failure when repository fails', () async {
        final failure = Failure(message: 'Error deleting home');
        when(mockHomesRepository.deleteHome(any)).thenAnswer((_) async => left(failure));

        final result = await deleteHomeUseCase.execute(testHomeId);

        expect(result.isLeft(), true);
        result.fold((failure) => expect(failure.message, 'Error deleting home'), (_) => fail('Should return failure'));
      });

      test('should return failure when repository throws exception', () async {
        when(mockHomesRepository.deleteHome(any)).thenThrow(Exception('Unexpected error'));

        final result = await deleteHomeUseCase.execute(testHomeId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'Unable to delete home'),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('dependency injection', () {
      test('should properly inject dependencies', () {
        final homesRepository = MockIHomesRepository();
        final assetsRepository = MockIAssetsRepository();
        DependencyInjector.instance.injectSingleton<IHomesRepository>(() => homesRepository);
        DependencyInjector.instance.injectSingleton<IAssetsRepository>(() => assetsRepository);

        final injection = DeleteHomeUseCaseInjection();
        injection.inject();

        final injectedUseCase = DependencyInjector.instance.get<DeleteHomeUseCase>();
        expect(injectedUseCase, isA<DeleteHomeUseCase>());
      });
    });
  });
}
