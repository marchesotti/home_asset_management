import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/get_homes_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<IHomesRepository>()])
import 'get_homes_use_case_test.mocks.dart';

void main() {
  late GetHomesUseCase getHomesUseCase;
  late MockIHomesRepository mockHomesRepository;

  setUp(() {
    mockHomesRepository = MockIHomesRepository();
    getHomesUseCase = GetHomesUseCase(mockHomesRepository);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  final testAddress = AddressModel(
    id: 'test_address_id',
    streetAddress1: '123 Test St',
    streetAddress2: 'Apt 1',
    city: 'Test City',
    state: UsState.CA,
    zip: '12345',
  );

  final testAddressNoApt = AddressModel(
    id: 'test_address_id_2',
    streetAddress1: '456 Test Ave',
    streetAddress2: '',
    city: 'Another City',
    state: UsState.NY,
    zip: '67890',
  );

  final testHomes = [
    HomeModel(id: 'home1', name: 'Test Home 1', address: testAddress),
    HomeModel(id: 'home2', name: 'Test Home 2', address: testAddress),
  ];

  group('GetHomesUseCase', () {
    test('should be a singleton via instance getter', () {
      final mockRepo = MockIHomesRepository();
      final useCase = GetHomesUseCase(mockRepo);
      DependencyInjector.instance.injectSingleton<GetHomesUseCase>(() => useCase);

      final instance1 = GetHomesUseCase.instance;
      final instance2 = GetHomesUseCase.instance;

      expect(instance1, isA<GetHomesUseCase>());
      expect(identical(instance1, instance2), true);
    });

    group('execute', () {
      test('should get homes successfully when repository succeeds', () async {
        when(mockHomesRepository.getHomes()).thenAnswer((_) async => right(testHomes));

        final result = await getHomesUseCase.execute();

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (homes) {
          expect(homes.length, 2);
          expect(homes[0].id, 'home1');
          expect(homes[0].name, 'Test Home 1');
          expect(homes[1].id, 'home2');
          expect(homes[1].name, 'Test Home 2');
          expect(homes[0].address.streetAddress1, '123 Test St');
          expect(homes[0].address.state, UsState.CA);
        });

        // Verify repository was called
        verify(mockHomesRepository.getHomes()).called(1);
      });

      test('should handle homes with different address formats', () async {
        final mixedHomes = [
          HomeModel(id: 'home1', name: 'Home with Apt', address: testAddress),
          HomeModel(id: 'home2', name: 'Home without Apt', address: testAddressNoApt),
        ];
        when(mockHomesRepository.getHomes()).thenAnswer((_) async => right(mixedHomes));

        final result = await getHomesUseCase.execute();

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (homes) {
          expect(homes.length, 2);
          expect(homes[0].address.streetAddress2, 'Apt 1');
          expect(homes[1].address.streetAddress2, '');
          expect(homes[0].address.state, UsState.CA);
          expect(homes[1].address.state, UsState.NY);
        });
      });

      test('should return empty list when repository returns empty', () async {
        when(mockHomesRepository.getHomes()).thenAnswer((_) async => right([]));

        final result = await getHomesUseCase.execute();

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (homes) => expect(homes, isEmpty));
      });

      test('should return failure when repository fails', () async {
        final failure = Failure(message: 'Error fetching homes');
        when(mockHomesRepository.getHomes()).thenAnswer((_) async => left(failure));

        final result = await getHomesUseCase.execute();

        expect(result.isLeft(), true);
        result.fold((failure) => expect(failure.message, 'Error fetching homes'), (_) => fail('Should return failure'));
      });

      test('should return failure when repository throws exception', () async {
        when(mockHomesRepository.getHomes()).thenThrow(Exception('Unexpected error'));

        final result = await getHomesUseCase.execute();

        expect(result.isLeft(), true);
        result.fold((failure) => expect(failure.message, 'Unable to get homes'), (_) => fail('Should return failure'));
      });
    });

    group('dependency injection', () {
      test('should properly inject dependencies', () {
        final mockRepo = MockIHomesRepository();
        DependencyInjector.instance.injectSingleton<IHomesRepository>(() => mockRepo);

        final injection = GetHomesUseCaseInjection();
        injection.inject();

        final injectedUseCase = DependencyInjector.instance.get<GetHomesUseCase>();
        expect(injectedUseCase, isA<GetHomesUseCase>());
      });
    });
  });
}
