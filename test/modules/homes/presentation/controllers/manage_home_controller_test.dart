import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/homes_controller.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/manage_home_controller.dart';

import 'manage_home_controller_test.mocks.dart';

@GenerateMocks([HomesController])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ManageHomeController manageHomeController;
  late MockHomesController mockHomesController;
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

    mockHomesController = MockHomesController();

    // Inject mock controller into the dependency injector
    DependencyInjector.instance.injectSingleton<HomesController>(() => mockHomesController);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  group('ManageHomeController - Create Mode', () {
    setUp(() {
      manageHomeController = ManageHomeController.getInstance(null);
    });

    test('should initialize with empty form fields when creating new home', () {
      expect(manageHomeController.isEditing, isFalse);
      expect(manageHomeController.nameController.text, isEmpty);
      expect(manageHomeController.streetAddress1Controller.text, isEmpty);
      expect(manageHomeController.streetAddress2Controller.text, isEmpty);
      expect(manageHomeController.cityController.text, isEmpty);
      expect(manageHomeController.stateController.value, isNull);
      expect(manageHomeController.zipController.text, isEmpty);
    });

    testWidgets('should create new home successfully', (WidgetTester tester) async {
      when(
        mockHomesController.createHome(
          name: anyNamed('name'),
          streetAddress1: anyNamed('streetAddress1'),
          streetAddress2: anyNamed('streetAddress2'),
          city: anyNamed('city'),
          state: anyNamed('state'),
          zip: anyNamed('zip'),
        ),
      ).thenAnswer((_) async => mockHome);

      manageHomeController.nameController.text = 'New Home';
      manageHomeController.streetAddress1Controller.text = '456 New St';
      manageHomeController.streetAddress2Controller.text = 'Unit 1';
      manageHomeController.cityController.text = 'New City';
      manageHomeController.stateController.value = UsState.NY;
      manageHomeController.zipController.text = '67890';

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: Form(key: manageHomeController.formKey, child: Container()))),
      );

      bool onSuccessCalled = false;
      await manageHomeController.save(
        onSuccess: (home) {
          onSuccessCalled = true;
          expect(home, equals(mockHome));
        },
      );

      verify(
        mockHomesController.createHome(
          name: 'New Home',
          streetAddress1: '456 New St',
          streetAddress2: 'Unit 1',
          city: 'New City',
          state: UsState.NY,
          zip: '67890',
        ),
      ).called(1);
      expect(onSuccessCalled, isTrue);
    });

    testWidgets('should not create home when form is invalid', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: manageHomeController.formKey,
              child: Material(
                child: TextFormField(controller: manageHomeController.nameController, validator: (_) => 'Invalid'),
              ),
            ),
          ),
        ),
      );

      bool onSuccessCalled = false;
      await manageHomeController.save(
        onSuccess: (home) {
          onSuccessCalled = true;
        },
      );

      verifyNever(
        mockHomesController.createHome(
          name: anyNamed('name'),
          streetAddress1: anyNamed('streetAddress1'),
          streetAddress2: anyNamed('streetAddress2'),
          city: anyNamed('city'),
          state: anyNamed('state'),
          zip: anyNamed('zip'),
        ),
      );
      expect(onSuccessCalled, isFalse);
    });
  });

  group('ManageHomeController - Edit Mode', () {
    setUp(() {
      manageHomeController = ManageHomeController.getInstance(mockHome);
    });

    test('should initialize with existing home data', () {
      expect(manageHomeController.isEditing, isTrue);
      expect(manageHomeController.nameController.text, equals(mockHome.name));
      expect(manageHomeController.streetAddress1Controller.text, equals(mockHome.address.streetAddress1));
      expect(manageHomeController.streetAddress2Controller.text, equals(mockHome.address.streetAddress2));
      expect(manageHomeController.cityController.text, equals(mockHome.address.city));
      expect(manageHomeController.stateController.value, equals(mockHome.address.state));
      expect(manageHomeController.zipController.text, equals(mockHome.address.zip));
    });

    testWidgets('should update existing home successfully', (WidgetTester tester) async {
      final updatedHome = mockHome.copyWith(
        name: 'Updated Home',
        address: mockAddress.copyWith(
          streetAddress1: '789 Updated St',
          streetAddress2: 'Suite 2',
          city: 'Updated City',
          state: UsState.TX,
          zip: '54321',
        ),
      );

      when(mockHomesController.updateHome(any)).thenAnswer((_) async {});

      manageHomeController.nameController.text = 'Updated Home';
      manageHomeController.streetAddress1Controller.text = '789 Updated St';
      manageHomeController.streetAddress2Controller.text = 'Suite 2';
      manageHomeController.cityController.text = 'Updated City';
      manageHomeController.stateController.value = UsState.TX;
      manageHomeController.zipController.text = '54321';

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: Form(key: manageHomeController.formKey, child: Container()))),
      );

      bool onSuccessCalled = false;
      await manageHomeController.save(
        onSuccess: (home) {
          onSuccessCalled = true;
          expect(home.name, equals(updatedHome.name));
          expect(home.address.streetAddress1, equals(updatedHome.address.streetAddress1));
          expect(home.address.streetAddress2, equals(updatedHome.address.streetAddress2));
          expect(home.address.city, equals(updatedHome.address.city));
          expect(home.address.state, equals(updatedHome.address.state));
          expect(home.address.zip, equals(updatedHome.address.zip));
        },
      );

      verify(mockHomesController.updateHome(any)).called(1);
      expect(onSuccessCalled, isTrue);
    });

    testWidgets('should not update home when form is invalid', (WidgetTester tester) async {
      manageHomeController.nameController.text = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: manageHomeController.formKey,
              child: Material(
                child: TextFormField(controller: manageHomeController.nameController, validator: (_) => 'Invalid'),
              ),
            ),
          ),
        ),
      );

      bool onSuccessCalled = false;
      await manageHomeController.save(
        onSuccess: (home) {
          onSuccessCalled = true;
        },
      );

      verifyNever(mockHomesController.updateHome(any));
      expect(onSuccessCalled, isFalse);
    });
  });
}
