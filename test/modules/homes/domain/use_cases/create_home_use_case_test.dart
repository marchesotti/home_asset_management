import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/create_home_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<IHomesRepository>()])
import 'create_home_use_case_test.mocks.dart';

void main() {
  late CreateHomeUseCase createHomeUseCase;
  late MockIHomesRepository mockHomesRepository;

  setUp(() {
    mockHomesRepository = MockIHomesRepository();
    createHomeUseCase = CreateHomeUseCase(mockHomesRepository);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  final testAddress = AddressModel(
    id: 'test_id',
    streetAddress1: '123 Test St',
    streetAddress2: 'Apt 1',
    city: 'Test City',
    state: UsState.CA,
    zip: '12345',
  );

  final testHome = HomeModel(id: 'test_id', name: 'Test Home', address: testAddress);

  group('CreateHomeUseCase', () {
    test('should be a singleton via instance getter', () {
      final mockRepo = MockIHomesRepository();
      final useCase = CreateHomeUseCase(mockRepo);
      DependencyInjector.instance.injectSingleton<CreateHomeUseCase>(() => useCase);

      final instance1 = CreateHomeUseCase.instance;
      final instance2 = CreateHomeUseCase.instance;

      expect(instance1, isA<CreateHomeUseCase>());
      expect(identical(instance1, instance2), true);
    });

    group('execute', () {
      test('should create home successfully when repository succeeds', () async {
        when(
          mockHomesRepository.createHome(
            name: anyNamed('name'),
            streetAddress1: anyNamed('streetAddress1'),
            streetAddress2: anyNamed('streetAddress2'),
            city: anyNamed('city'),
            state: anyNamed('state'),
            zip: anyNamed('zip'),
          ),
        ).thenAnswer((_) async => right(testHome));

        final result = await createHomeUseCase.execute(
          name: 'Test Home',
          streetAddress1: '123 Test St',
          streetAddress2: 'Apt 1',
          city: 'Test City',
          state: UsState.CA,
          zip: '12345',
        );

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (home) {
          expect(home.name, testHome.name);
          expect(home.address.streetAddress1, testHome.address.streetAddress1);
          expect(home.address.city, testHome.address.city);
          expect(home.address.state, testHome.address.state);
          expect(home.address.zip, testHome.address.zip);
          expect(home.address.streetAddress2, testHome.address.streetAddress2);
        });

        verify(
          mockHomesRepository.createHome(
            name: 'Test Home',
            streetAddress1: '123 Test St',
            streetAddress2: 'Apt 1',
            city: 'Test City',
            state: UsState.CA,
            zip: '12345',
          ),
        ).called(1);
      });

      test('should create home successfully with empty streetAddress2', () async {
        final homeWithoutApt = HomeModel(
          id: 'test_id',
          name: 'Test Home',
          address: testAddress.copyWith(streetAddress2: ''),
        );

        when(
          mockHomesRepository.createHome(
            name: anyNamed('name'),
            streetAddress1: anyNamed('streetAddress1'),
            streetAddress2: anyNamed('streetAddress2'),
            city: anyNamed('city'),
            state: anyNamed('state'),
            zip: anyNamed('zip'),
          ),
        ).thenAnswer((_) async => right(homeWithoutApt));

        final result = await createHomeUseCase.execute(
          name: 'Test Home',
          streetAddress1: '123 Test St',
          streetAddress2: '',
          city: 'Test City',
          state: UsState.CA,
          zip: '12345',
        );

        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (home) {
          expect(home.address.streetAddress2, '');
        });
      });

      test('should return failure when repository fails', () async {
        final failure = Failure(message: 'Error creating home');
        when(
          mockHomesRepository.createHome(
            name: anyNamed('name'),
            streetAddress1: anyNamed('streetAddress1'),
            streetAddress2: anyNamed('streetAddress2'),
            city: anyNamed('city'),
            state: anyNamed('state'),
            zip: anyNamed('zip'),
          ),
        ).thenAnswer((_) async => left(failure));

        final result = await createHomeUseCase.execute(
          name: 'Test Home',
          streetAddress1: '123 Test St',
          streetAddress2: 'Apt 1',
          city: 'Test City',
          state: UsState.CA,
          zip: '12345',
        );

        expect(result.isLeft(), true);
        result.fold((failure) => expect(failure.message, 'Error creating home'), (_) => fail('Should return failure'));
      });

      test('should return failure when repository throws exception', () async {
        when(
          mockHomesRepository.createHome(
            name: anyNamed('name'),
            streetAddress1: anyNamed('streetAddress1'),
            streetAddress2: anyNamed('streetAddress2'),
            city: anyNamed('city'),
            state: anyNamed('state'),
            zip: anyNamed('zip'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        final result = await createHomeUseCase.execute(
          name: 'Test Home',
          streetAddress1: '123 Test St',
          streetAddress2: 'Apt 1',
          city: 'Test City',
          state: UsState.CA,
          zip: '12345',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, 'Unable to create home'),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('dependency injection', () {
      test('should properly inject dependencies', () {
        final mockRepo = MockIHomesRepository();
        DependencyInjector.instance.injectSingleton<IHomesRepository>(() => mockRepo);

        final injection = CreateHomeUseCaseInjection();
        injection.inject();

        final injectedUseCase = DependencyInjector.instance.get<CreateHomeUseCase>();
        expect(injectedUseCase, isA<CreateHomeUseCase>());
      });
    });
  });
}
