import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/create_home_asset_use_case.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/delete_home_assets_use_case.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/get_home_assets_use_case.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/home_controller.dart';

import 'home_controller_test.mocks.dart';

@GenerateMocks([GetAssetsUseCase, CreateHomeAssetUseCase, DeleteHomeAssetUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomeController homeController;
  late HomeModel mockHome;
  late AddressModel mockAddress;
  late MockGetAssetsUseCase mockGetAssetsUseCase;
  late MockCreateHomeAssetUseCase mockCreateHomeAssetUseCase;
  late MockDeleteHomeAssetUseCase mockDeleteHomeAssetUseCase;

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

    mockGetAssetsUseCase = MockGetAssetsUseCase();
    mockCreateHomeAssetUseCase = MockCreateHomeAssetUseCase();
    mockDeleteHomeAssetUseCase = MockDeleteHomeAssetUseCase();

    // Inject mock use cases into the dependency injector
    DependencyInjector.instance.injectSingleton<GetAssetsUseCase>(() => mockGetAssetsUseCase);
    DependencyInjector.instance.injectSingleton<CreateHomeAssetUseCase>(() => mockCreateHomeAssetUseCase);
    DependencyInjector.instance.injectSingleton<DeleteHomeAssetUseCase>(() => mockDeleteHomeAssetUseCase);

    homeController = HomeController.getInstance(mockHome);
  });

  tearDown(() {
    DependencyInjector.instance.resetAll();
  });

  group('HomeController', () {
    test('should initialize with correct home', () {
      expect(homeController.home, equals(mockHome));
      expect(homeController.homeNotifier.value, equals(mockHome));
      expect(homeController.assetsNotifier.value, isNull);
    });

    group('fetchAssets', () {
      test('should update assetsNotifier with assets on success', () async {
        final mockAssets = [
          AssetModel(id: 'asset1', type: AssetTypeEnum.refrigerator, homeId: mockHome.id),
          AssetModel(id: 'asset2', type: AssetTypeEnum.airConditioner, homeId: mockHome.id),
        ];

        when(mockGetAssetsUseCase.execute(mockHome.id)).thenAnswer((_) async => Right(mockAssets));

        await homeController.fetchAssets();

        expect(homeController.assetsNotifier.value, equals(mockAssets));
        verify(mockGetAssetsUseCase.execute(mockHome.id)).called(1);
      });

      test('should set empty list and show error on failure', () async {
        when(
          mockGetAssetsUseCase.execute(mockHome.id),
        ).thenAnswer((_) async => Left(Failure(message: 'Error fetching assets')));

        await homeController.fetchAssets();

        expect(homeController.assetsNotifier.value, isEmpty);
        verify(mockGetAssetsUseCase.execute(mockHome.id)).called(1);
      });
    });

    group('createAsset', () {
      test('should add new asset to assetsNotifier on success', () async {
        final newAsset = AssetModel(id: 'new-asset', type: AssetTypeEnum.refrigerator, homeId: mockHome.id);

        when(
          mockCreateHomeAssetUseCase.execute(mockHome.id, AssetTypeEnum.refrigerator),
        ).thenAnswer((_) async => Right(newAsset));

        homeController.assetsNotifier.value = [];
        await homeController.createAsset(AssetTypeEnum.refrigerator);

        expect(homeController.assetsNotifier.value, contains(newAsset));
        verify(mockCreateHomeAssetUseCase.execute(mockHome.id, AssetTypeEnum.refrigerator)).called(1);
      });

      test('should show error and not update assetsNotifier on failure', () async {
        when(
          mockCreateHomeAssetUseCase.execute(mockHome.id, AssetTypeEnum.refrigerator),
        ).thenAnswer((_) async => Left(Failure(message: 'Error creating asset')));

        final initialAssets = [AssetModel(id: 'asset1', type: AssetTypeEnum.refrigerator, homeId: mockHome.id)];
        homeController.assetsNotifier.value = initialAssets;

        await homeController.createAsset(AssetTypeEnum.refrigerator);

        expect(homeController.assetsNotifier.value, equals(initialAssets));
        verify(mockCreateHomeAssetUseCase.execute(mockHome.id, AssetTypeEnum.refrigerator)).called(1);
      });
    });

    group('deleteAsset', () {
      test('should remove asset from assetsNotifier on success', () async {
        final assetToDelete = AssetModel(id: 'asset-to-delete', type: AssetTypeEnum.refrigerator, homeId: mockHome.id);
        final otherAsset = AssetModel(id: 'other-asset', type: AssetTypeEnum.airConditioner, homeId: mockHome.id);

        when(mockDeleteHomeAssetUseCase.execute(assetToDelete.id)).thenAnswer((_) async => Right(null));

        homeController.assetsNotifier.value = [assetToDelete, otherAsset];
        await homeController.deleteAsset(assetToDelete.id);

        expect(homeController.assetsNotifier.value, equals([otherAsset]));
        verify(mockDeleteHomeAssetUseCase.execute(assetToDelete.id)).called(1);
      });

      test('should restore asset to assetsNotifier on failure', () async {
        final assetToDelete = AssetModel(id: 'asset-to-delete', type: AssetTypeEnum.refrigerator, homeId: mockHome.id);

        when(
          mockDeleteHomeAssetUseCase.execute(assetToDelete.id),
        ).thenAnswer((_) async => Left(Failure(message: 'Error deleting asset')));

        homeController.assetsNotifier.value = [assetToDelete];
        await homeController.deleteAsset(assetToDelete.id);

        expect(homeController.assetsNotifier.value, contains(assetToDelete));
        verify(mockDeleteHomeAssetUseCase.execute(assetToDelete.id)).called(1);
      });

      test('should do nothing when asset id not found', () async {
        final existingAsset = AssetModel(id: 'existing-asset', type: AssetTypeEnum.refrigerator, homeId: mockHome.id);

        homeController.assetsNotifier.value = [existingAsset];
        await homeController.deleteAsset('non-existent-id');

        expect(homeController.assetsNotifier.value, equals([existingAsset]));
        verifyNever(mockDeleteHomeAssetUseCase.execute(any));
      });
    });
  });
}
