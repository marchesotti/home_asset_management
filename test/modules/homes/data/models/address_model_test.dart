import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';

void main() {
  group('AddressModel', () {
    final testAddress = AddressModel(
      id: 'test-id',
      streetAddress1: '123 Main St',
      streetAddress2: 'Apt 4B',
      city: 'New York',
      state: UsState.NY,
      zip: '10001',
    );

    test('constructor creates instance with correct values', () {
      expect(testAddress.id, equals('test-id'));
      expect(testAddress.streetAddress1, equals('123 Main St'));
      expect(testAddress.streetAddress2, equals('Apt 4B'));
      expect(testAddress.city, equals('New York'));
      expect(testAddress.state, equals(UsState.NY));
      expect(testAddress.zip, equals('10001'));
    });

    group('copyWith', () {
      test('returns new instance with updated values', () {
        final updatedAddress = testAddress.copyWith(
          streetAddress1: '456 Oak Ave',
          city: 'Los Angeles',
          state: UsState.CA,
        );

        expect(updatedAddress.id, equals(testAddress.id));
        expect(updatedAddress.streetAddress1, equals('456 Oak Ave'));
        expect(updatedAddress.streetAddress2, equals(testAddress.streetAddress2));
        expect(updatedAddress.city, equals('Los Angeles'));
        expect(updatedAddress.state, equals(UsState.CA));
        expect(updatedAddress.zip, equals(testAddress.zip));
      });

      test('returns same values when no parameters provided', () {
        final copiedAddress = testAddress.copyWith();
        expect(copiedAddress.id, equals(testAddress.id));
        expect(copiedAddress.streetAddress1, equals(testAddress.streetAddress1));
        expect(copiedAddress.streetAddress2, equals(testAddress.streetAddress2));
        expect(copiedAddress.city, equals(testAddress.city));
        expect(copiedAddress.state, equals(testAddress.state));
        expect(copiedAddress.zip, equals(testAddress.zip));
      });
    });

    group('toString', () {
      test('returns correct string with streetAddress2', () {
        expect(testAddress.toString(), equals('123 Main St, Apt 4B, New York, NY, 10001'));
      });

      test('returns correct string without streetAddress2', () {
        final addressWithoutStreet2 = AddressModel(
          id: 'test-id',
          streetAddress1: '123 Main St',
          streetAddress2: '',
          city: 'New York',
          state: UsState.NY,
          zip: '10001',
        );

        expect(addressWithoutStreet2.toString(), equals('123 Main St, New York, NY, 10001'));
      });
    });
  });
}
