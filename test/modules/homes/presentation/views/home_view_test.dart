import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/delete_home_assets_use_case.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/get_home_assets_use_case.dart';
import 'package:home_asset_management/modules/assets/presentation/extensions/asset_type_enum_extension.dart';
import 'package:home_asset_management/modules/assets/presentation/views/search_asset_view.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/presentation/views/home_view.dart';
import 'package:home_asset_management/modules/homes/presentation/views/manage_home_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../config/hive.dart';

@GenerateNiceMocks([MockSpec<IHomesRepository>(), MockSpec<IAssetsRepository>()])
import 'home_view_test.mocks.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Widget createWidgetUnderTest(HomeModel home) {
  return MaterialApp(navigatorKey: navigatorKey, home: HomeView(home));
}

void main() {
  late MockIHomesRepository mockHomesRepository;
  late MockIAssetsRepository mockAssetsRepository;
  late HomeModel testHomeWithAssets;
  late HomeModel testHomeWithoutAssets;
  late List<AssetModel> testAssets;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeHiveForTests();
  });

  setUp(() async {
    DependencyInjector.instance.resetAll();

    mockHomesRepository = MockIHomesRepository();
    mockAssetsRepository = MockIAssetsRepository();

    testHomeWithAssets = HomeModel(
      id: '1',
      name: 'Test Home',
      address: AddressModel(
        id: '1',
        streetAddress1: '123 Test St',
        streetAddress2: 'Apt 4B',
        city: 'Test City',
        state: UsState.CA,
        zip: '12345',
      ),
    );

    testHomeWithoutAssets = HomeModel(
      id: '2',
      name: 'Test Home 2',
      address: AddressModel(
        id: '2',
        streetAddress1: '123 Test St',
        streetAddress2: 'Apt 4B',
        city: 'Test City',
        state: UsState.CA,
        zip: '12345',
      ),
    );

    testAssets = [
      AssetModel(id: '1', type: AssetTypeEnum.airConditioner, homeId: testHomeWithAssets.id),
      AssetModel(id: '2', type: AssetTypeEnum.battery, homeId: testHomeWithAssets.id),
    ];

    when(mockAssetsRepository.getHomeAssets(testHomeWithAssets.id)).thenAnswer((_) async => right(testAssets));
    when(mockAssetsRepository.getHomeAssets(testHomeWithoutAssets.id)).thenAnswer((_) async => right([]));
    when(mockAssetsRepository.deleteHomeAsset(any)).thenAnswer((_) async => right(null));

    // Inject dependencies in correct order
    DependencyInjector.instance.injectSingleton<IHomesRepository>(() => mockHomesRepository);
    DependencyInjector.instance.injectSingleton<IAssetsRepository>(() => mockAssetsRepository);
    DependencyInjector.instance.injectSingleton<GetAssetsUseCase>(() => GetAssetsUseCase(mockAssetsRepository));
    DependencyInjector.instance.injectSingleton<DeleteHomeAssetUseCase>(
      () => DeleteHomeAssetUseCase(mockAssetsRepository),
    );
  });

  tearDown(() async {
    await clearHiveForTests();
    DependencyInjector.instance.resetAll();
  });

  testWidgets('HomeView displays home information correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHomeWithAssets));

    expect(find.text('Test Home'), findsOneWidget);
    expect(find.text('123 Test St, Apt 4B, Test City, CA, 12345'), findsOneWidget);
  });

  testWidgets('HomeView shows loading indicator when fetching assets', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHomeWithAssets));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomeView shows empty state when no assets', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHomeWithoutAssets));
    await tester.pumpAndSettle();

    expect(find.text('No assets found'), findsOneWidget);
  });

  testWidgets('HomeView displays assets when available', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHomeWithAssets));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(testAssets.first.type.title), findsOneWidget);
  });

  testWidgets('HomeView navigates to ManageHomeView when edit button is pressed', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHomeWithAssets));

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.byType(ManageHomeView), findsOneWidget);
  });

  testWidgets('HomeView navigates to SearchAssetView when the FloatingActionButton is pressed', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHomeWithAssets));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(SearchAssetView), findsOneWidget);
  });

  testWidgets('HomeView can delete assets', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHomeWithAssets));
    await tester.pumpAndSettle();

    for (AssetModel asset in testAssets) {
      expect(find.text(asset.type.title), findsOneWidget);
    }

    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').first);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(testAssets[0].type.title), findsNothing);
    expect(find.text(testAssets[1].type.title), findsOneWidget);
  });
}
