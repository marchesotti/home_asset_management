import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/create_home_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/delete_home_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/get_homes_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/update_home_use_case.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/homes_controller.dart';

import 'homes_controller_test.mocks.dart';

@GenerateMocks([GetHomesUseCase, CreateHomeUseCase, UpdateHomeUseCase, DeleteHomeUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomesController homesController;
  late MockGetHomesUseCase mockGetHomesUseCase;
  late MockCreateHomeUseCase mockCreateHomeUseCase;
  late MockUpdateHomeUseCase mockUpdateHomeUseCase;
  late MockDeleteHomeUseCase mockDeleteHomeUseCase;
  late HomeModel mockHome;
  late AddressModel mockAddress;

  setUp(() {
    mockAddress = AddressModel(
      id: 'test-address-id',
      streetAddress1: '123 Test St',
      streetAddress2: 'Apt 4B',
      city: 'Test City',
      state: UsState.CA,
      zip: '12345',
    );

    mockHome = HomeModel(id: 'test-home-id', name: 'Test Home', address: mockAddress);

    mockGetHomesUseCase = MockGetHomesUseCase();
    mockCreateHomeUseCase = MockCreateHomeUseCase();
    mockUpdateHomeUseCase = MockUpdateHomeUseCase();
    mockDeleteHomeUseCase = MockDeleteHomeUseCase();

    // Inject mock use cases into the dependency injector
    DependencyInjector.instance.injectSingleton<GetHomesUseCase>(() => mockGetHomesUseCase);
    DependencyInjector.instance.injectSingleton<CreateHomeUseCase>(() => mockCreateHomeUseCase);
    DependencyInjector.instance.injectSingleton<UpdateHomeUseCase>(() => mockUpdateHomeUseCase);
    DependencyInjector.instance.injectSingleton<DeleteHomeUseCase>(() => mockDeleteHomeUseCase);

    homesController = HomesController.instance;
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  group('HomesController', () {
    test('should initialize with null homes list', () {
      expect(homesController.homesNotifier.value, isNull);
    });

    group('fetchHomes', () {
      test('should update homesNotifier with homes on success', () async {
        final mockHomes = [mockHome, HomeModel(id: 'test-home-id-2', name: 'Test Home 2', address: mockAddress)];

        when(mockGetHomesUseCase.execute()).thenAnswer((_) async => Right(mockHomes));

        await homesController.fetchHomes();

        expect(homesController.homesNotifier.value, equals(mockHomes));
        verify(mockGetHomesUseCase.execute()).called(1);
      });

      test('should set empty list and show error on failure', () async {
        when(mockGetHomesUseCase.execute()).thenAnswer((_) async => Left(Failure(message: 'Error fetching homes')));

        await homesController.fetchHomes();

        expect(homesController.homesNotifier.value, isEmpty);
        verify(mockGetHomesUseCase.execute()).called(1);
      });
    });

    group('createHome', () {
      test('should add new home to homesNotifier on success', () async {
        when(
          mockCreateHomeUseCase.execute(
            name: 'New Home',
            streetAddress1: '123 New St',
            streetAddress2: 'Apt 1',
            city: 'New City',
            state: UsState.CA,
            zip: '54321',
          ),
        ).thenAnswer((_) async => Right(mockHome));

        homesController.homesNotifier.value = [];
        final result = await homesController.createHome(
          name: 'New Home',
          streetAddress1: '123 New St',
          streetAddress2: 'Apt 1',
          city: 'New City',
          state: UsState.CA,
          zip: '54321',
        );

        expect(result, equals(mockHome));
        expect(homesController.homesNotifier.value, contains(mockHome));
        verify(
          mockCreateHomeUseCase.execute(
            name: 'New Home',
            streetAddress1: '123 New St',
            streetAddress2: 'Apt 1',
            city: 'New City',
            state: UsState.CA,
            zip: '54321',
          ),
        ).called(1);
      });

      test('should show error and not update homesNotifier on failure', () async {
        when(
          mockCreateHomeUseCase.execute(
            name: 'New Home',
            streetAddress1: '123 New St',
            streetAddress2: 'Apt 1',
            city: 'New City',
            state: UsState.CA,
            zip: '54321',
          ),
        ).thenAnswer((_) async => Left(Failure(message: 'Error creating home')));

        final initialHomes = [mockHome];
        homesController.homesNotifier.value = initialHomes;

        final result = await homesController.createHome(
          name: 'New Home',
          streetAddress1: '123 New St',
          streetAddress2: 'Apt 1',
          city: 'New City',
          state: UsState.CA,
          zip: '54321',
        );

        expect(result, isNull);
        expect(homesController.homesNotifier.value, equals(initialHomes));
        verify(
          mockCreateHomeUseCase.execute(
            name: 'New Home',
            streetAddress1: '123 New St',
            streetAddress2: 'Apt 1',
            city: 'New City',
            state: UsState.CA,
            zip: '54321',
          ),
        ).called(1);
      });
    });

    group('updateHome', () {
      test('should update home in homesNotifier on success', () async {
        final updatedHome = HomeModel(id: mockHome.id, name: 'Updated Home', address: mockAddress);

        when(mockUpdateHomeUseCase.execute(updatedHome)).thenAnswer((_) async => Right(null));

        homesController.homesNotifier.value = [mockHome];
        await homesController.updateHome(updatedHome);

        expect(homesController.homesNotifier.value?.first, equals(updatedHome));
        verify(mockUpdateHomeUseCase.execute(updatedHome)).called(1);
      });

      test('should restore original home on failure', () async {
        final updatedHome = HomeModel(id: mockHome.id, name: 'Updated Home', address: mockAddress);

        when(
          mockUpdateHomeUseCase.execute(updatedHome),
        ).thenAnswer((_) async => Left(Failure(message: 'Error updating home')));

        homesController.homesNotifier.value = [mockHome];
        await homesController.updateHome(updatedHome);

        expect(homesController.homesNotifier.value?.first, equals(mockHome));
        verify(mockUpdateHomeUseCase.execute(updatedHome)).called(1);
      });

      test('should do nothing when home id not found', () async {
        final nonExistentHome = HomeModel(id: 'non-existent-id', name: 'Non-existent Home', address: mockAddress);

        homesController.homesNotifier.value = [mockHome];
        await homesController.updateHome(nonExistentHome);

        expect(homesController.homesNotifier.value?.first, equals(mockHome));
        verifyNever(mockUpdateHomeUseCase.execute(any));
      });
    });

    group('deleteHome', () {
      test('should remove home from homesNotifier on success', () async {
        when(mockDeleteHomeUseCase.execute(mockHome.id)).thenAnswer((_) async => Right(null));

        homesController.homesNotifier.value = [mockHome];
        await homesController.deleteHome(mockHome.id);

        expect(homesController.homesNotifier.value, isEmpty);
        verify(mockDeleteHomeUseCase.execute(mockHome.id)).called(1);
      });

      test('should restore home to homesNotifier on failure', () async {
        when(
          mockDeleteHomeUseCase.execute(mockHome.id),
        ).thenAnswer((_) async => Left(Failure(message: 'Error deleting home')));

        homesController.homesNotifier.value = [mockHome];
        await homesController.deleteHome(mockHome.id);

        expect(homesController.homesNotifier.value, contains(mockHome));
        verify(mockDeleteHomeUseCase.execute(mockHome.id)).called(1);
      });

      test('should do nothing when home id not found', () async {
        homesController.homesNotifier.value = [mockHome];
        await homesController.deleteHome('non-existent-id');

        expect(homesController.homesNotifier.value, equals([mockHome]));
        verifyNever(mockDeleteHomeUseCase.execute(any));
      });
    });
  });
}
