import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/create_home_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/delete_home_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/get_homes_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/update_home_use_case.dart';
import 'package:home_asset_management/modules/homes/presentation/views/homes_view.dart';
import 'package:home_asset_management/modules/homes/presentation/views/manage_home_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../config/hive.dart';

@GenerateNiceMocks([MockSpec<IHomesRepository>(), MockSpec<IAssetsRepository>()])
import 'homes_view_test.mocks.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Widget createWidgetUnderTest() {
  return MaterialApp(navigatorKey: navigatorKey, home: const HomesView());
}

void main() {
  late MockIHomesRepository mockHomesRepository;
  late MockIAssetsRepository mockAssetsRepository;
  late List<HomeModel> testHomes;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeHiveForTests();
  });

  setUp(() async {
    DependencyInjector.instance.resetAll();

    mockHomesRepository = MockIHomesRepository();
    mockAssetsRepository = MockIAssetsRepository();
    final testAddress = AddressModel(
      id: 'test_address_id',
      streetAddress1: '123 Test St',
      streetAddress2: 'Apt 1',
      city: 'Test City',
      state: UsState.CA,
      zip: '12345',
    );

    testHomes = [
      HomeModel(id: 'home1', name: 'Test Home 1', address: testAddress),
      HomeModel(id: 'home2', name: 'Test Home 2', address: testAddress),
    ];

    // Setup default mock behavior
    when(mockHomesRepository.getHomes()).thenAnswer((_) async => right(testHomes));
    when(mockHomesRepository.deleteHome(any)).thenAnswer((_) async => right(null));

    // Inject dependencies in correct order
    DependencyInjector.instance.injectSingleton<IHomesRepository>(() => mockHomesRepository);
    DependencyInjector.instance.injectSingleton<GetHomesUseCase>(() => GetHomesUseCase(mockHomesRepository));
    DependencyInjector.instance.injectSingleton<CreateHomeUseCase>(() => CreateHomeUseCase(mockHomesRepository));
    DependencyInjector.instance.injectSingleton<UpdateHomeUseCase>(() => UpdateHomeUseCase(mockHomesRepository));
    DependencyInjector.instance.injectSingleton<DeleteHomeUseCase>(
      () => DeleteHomeUseCase(mockHomesRepository, mockAssetsRepository),
    );
  });

  tearDown(() async {
    await clearHiveForTests();
    DependencyInjector.instance.resetAll();
  });

  group('HomesView', () {
    testWidgets('shows loading indicator when homes are null', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no homes exist', (tester) async {
      when(mockHomesRepository.getHomes()).thenAnswer((_) async => right([]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No homes found'), findsOneWidget);
    });

    testWidgets('shows list of homes when homes exist', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Home 1'), findsOneWidget);
      expect(find.text('Test Home 2'), findsOneWidget);
      expect(find.text('123 Test St, Apt 1, Test City, CA, 12345'), findsNWidgets(2));
    });

    testWidgets('navigates to ManageHomeView when FloatingActionButton is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(ManageHomeView), findsOneWidget);
    });

    testWidgets('shows correct AppBar title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Homes'), findsOneWidget);
    });

    testWidgets('updates UI after successful delete', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Home 1'), findsOneWidget);
      expect(find.text('Test Home 2'), findsOneWidget);

      when(mockHomesRepository.deleteHome('home1')).thenAnswer((_) async => right(null));
      when(mockAssetsRepository.getHomeAssets(any)).thenAnswer((_) async => right([]));
      when(mockAssetsRepository.deleteHomeAsset(any)).thenAnswer((_) async => right(null));

      await tester.tap(find.byIcon(Icons.more_horiz).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').first);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Test Home 1'), findsNothing);
      expect(find.text('Test Home 2'), findsOneWidget);
    });

    testWidgets('reverts UI on delete failure', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Home 1'), findsOneWidget);
      expect(find.text('Test Home 2'), findsOneWidget);

      // Setup mock for delete failure
      when(mockHomesRepository.deleteHome('home1')).thenAnswer((_) async => left(Failure(message: 'Delete failed')));

      await tester.tap(find.byIcon(Icons.more_horiz).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').first);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Test Home 1'), findsOneWidget);
      expect(find.text('Test Home 2'), findsOneWidget);
    });
  });
}
