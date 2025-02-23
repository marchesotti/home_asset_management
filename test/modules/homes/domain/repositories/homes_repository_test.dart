import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/domain/repositories/homes_repository.dart';

import '../../../../config/hive.dart';

void main() {
  late HomesRepository homesRepository;
  late Box<HomeModel> homesBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await initializeHiveForTests();

    homesBox = await Hive.openBox<HomeModel>(HiveBoxes.homes);

    homesRepository = HomesRepository();
  });

  tearDown(() async {
    await clearHiveForTests();
  });

  group('getHomes', () {
    test('should return empty list when no homes exist', () async {
      final result = await homesRepository.getHomes();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('should return list of homes when homes exist', () async {
      final address = AddressModel(
        id: 'test_address_id',
        streetAddress1: '123 Test St',
        streetAddress2: 'Apt 1',
        city: 'Test City',
        state: UsState.CA,
        zip: '12345',
      );
      final home = HomeModel(id: 'test_home_id', name: 'Test Home', address: address);

      await homesBox.put(home.id, home);

      final result = await homesRepository.getHomes();

      expect(result.isRight(), true);
      final homes = result.getOrElse(() => []);
      expect(homes.length, 1);
      expect(homes.first.id, 'test_home_id');
      expect(homes.first.name, 'Test Home');
      expect(homes.first.address.streetAddress1, '123 Test St');
    });
  });

  group('createHome', () {
    test('should create home and address successfully', () async {
      final result = await homesRepository.createHome(
        name: 'New Home',
        streetAddress1: '456 New St',
        streetAddress2: 'Unit 2',
        city: 'New City',
        state: UsState.NY,
        zip: '67890',
      );

      expect(result.isRight(), true);
      final createdHome = result.getOrElse(() => throw Exception('Failed to get home'));

      expect(createdHome.name, 'New Home');
      expect(createdHome.address.streetAddress1, '456 New St');
      expect(createdHome.address.streetAddress2, 'Unit 2');
      expect(createdHome.address.city, 'New City');
      expect(createdHome.address.state, UsState.NY);
      expect(createdHome.address.zip, '67890');

      expect(homesBox.values.length, 1);
    });
  });

  group('updateHome', () {
    late HomeModel existingHome;
    late AddressModel existingAddress;

    setUp(() async {
      existingAddress = AddressModel(
        id: 'existing_address_id',
        streetAddress1: 'Old St',
        streetAddress2: 'Old Unit',
        city: 'Old City',
        state: UsState.CA,
        zip: '11111',
      );
      existingHome = HomeModel(id: 'existing_home_id', name: 'Old Name', address: existingAddress);

      await homesBox.put(existingHome.id, existingHome);
    });

    test('should update home and address successfully', () async {
      final updatedAddress = existingAddress.copyWith(streetAddress1: 'Updated St', city: 'Updated City');
      final updatedHome = existingHome.copyWith(name: 'Updated Name', address: updatedAddress);

      final result = await homesRepository.updateHome(updatedHome);

      expect(result.isRight(), true);

      final savedHome = homesBox.get(existingHome.id);
      expect(savedHome?.name, 'Updated Name');
      expect(savedHome?.address.streetAddress1, 'Updated St');
      expect(savedHome?.address.city, 'Updated City');
    });
  });

  group('deleteHome', () {
    late HomeModel existingHome;
    late AddressModel existingAddress;

    setUp(() async {
      existingAddress = AddressModel(
        id: 'existing_address_id',
        streetAddress1: 'Delete St',
        streetAddress2: 'Delete Unit',
        city: 'Delete City',
        state: UsState.CA,
        zip: '99999',
      );
      existingHome = HomeModel(id: 'existing_home_id', name: 'Delete Home', address: existingAddress);

      await homesBox.put(existingHome.id, existingHome);
    });

    test('should delete home and address successfully', () async {
      final result = await homesRepository.deleteHome(existingHome.id);

      expect(result.isRight(), true);

      expect(homesBox.get(existingHome.id), isNull);
    });

    test('should return failure when home does not exist', () async {
      final result = await homesRepository.deleteHome('non_existent_id');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Home not found'),
        (_) => fail('Should have returned a failure'),
      );
    });
  });
}
