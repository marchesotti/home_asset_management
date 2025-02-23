import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

void main() {
  group('HomeModel', () {
    final testAddress = AddressModel(
      id: 'address-id',
      streetAddress1: '123 Main St',
      streetAddress2: 'Apt 4B',
      city: 'New York',
      state: UsState.NY,
      zip: '10001',
    );

    final testHome = HomeModel(id: 'home-id', name: 'My Home', address: testAddress);

    test('constructor creates instance with correct values', () {
      expect(testHome.id, equals('home-id'));
      expect(testHome.name, equals('My Home'));
      expect(testHome.address, equals(testAddress));

      // Verify nested address properties
      expect(testHome.address.streetAddress1, equals('123 Main St'));
      expect(testHome.address.streetAddress2, equals('Apt 4B'));
      expect(testHome.address.city, equals('New York'));
      expect(testHome.address.state, equals(UsState.NY));
      expect(testHome.address.zip, equals('10001'));
    });

    group('copyWith', () {
      test('returns new instance with updated name', () {
        final updatedHome = testHome.copyWith(name: 'New Home Name');

        expect(updatedHome.id, equals(testHome.id));
        expect(updatedHome.name, equals('New Home Name'));
        expect(updatedHome.address, equals(testHome.address));
      });

      test('returns new instance with updated address', () {
        final newAddress = AddressModel(
          id: 'new-address-id',
          streetAddress1: '456 Oak Ave',
          streetAddress2: 'Unit 2',
          city: 'Los Angeles',
          state: UsState.CA,
          zip: '90001',
        );

        final updatedHome = testHome.copyWith(address: newAddress);

        expect(updatedHome.id, equals(testHome.id));
        expect(updatedHome.name, equals(testHome.name));
        expect(updatedHome.address, equals(newAddress));
        expect(updatedHome.address.streetAddress1, equals('456 Oak Ave'));
        expect(updatedHome.address.city, equals('Los Angeles'));
        expect(updatedHome.address.state, equals(UsState.CA));
      });

      test('returns new instance with updated name and address', () {
        final newAddress = AddressModel(
          id: 'new-address-id',
          streetAddress1: '456 Oak Ave',
          streetAddress2: 'Unit 2',
          city: 'Los Angeles',
          state: UsState.CA,
          zip: '90001',
        );

        final updatedHome = testHome.copyWith(name: 'New Home Name', address: newAddress);

        expect(updatedHome.id, equals(testHome.id));
        expect(updatedHome.name, equals('New Home Name'));
        expect(updatedHome.address, equals(newAddress));
      });

      test('returns same values when no parameters provided', () {
        final copiedHome = testHome.copyWith();

        expect(copiedHome.id, equals(testHome.id));
        expect(copiedHome.name, equals(testHome.name));
        expect(copiedHome.address, equals(testHome.address));
      });
    });
  });
}
