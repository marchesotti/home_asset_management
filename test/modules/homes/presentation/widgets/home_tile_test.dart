import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:home_asset_management/core/consts/hive_boxes.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/homes/data/models/address_model.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/views/home_view.dart';
import 'package:home_asset_management/modules/homes/presentation/views/manage_home_view.dart';
import 'package:home_asset_management/modules/homes/presentation/widgets/home_tile.dart';

import '../../../../config/hive.dart';

Widget createWidgetUnderTest(HomeModel home, VoidCallback onDeleteTap) {
  return MaterialApp(home: Scaffold(body: HomeTile(home, onDeleteTap: onDeleteTap)));
}

void main() {
  late HomeModel testHome;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await initializeHiveForTests();

    await Hive.openBox<HomeModel>(HiveBoxes.homes);
    await Hive.openBox<AssetModel>(HiveBoxes.assets);

    testHome = HomeModel(
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
  });

  testWidgets('HomeTile displays home information correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHome, () {}));

    expect(find.text('Test Home'), findsOneWidget);
    expect(find.text('123 Test St, Apt 4B, Test City, CA, 12345'), findsOneWidget);
  });

  testWidgets('HomeTile navigates to HomeView when tapped', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHome, () {}));

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(HomeView), findsOneWidget);
  });

  testWidgets('HomeTile shows menu when menu button is tapped', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHome, () {}));

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('HomeTile navigates to ManageHomeView when edit is tapped', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testHome, () {}));

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byType(ManageHomeView), findsOneWidget);
  });

  testWidgets('HomeTile calls onDeleteTap when delete is pressed', (tester) async {
    bool deletePressed = false;

    await tester.pumpWidget(createWidgetUnderTest(testHome, () => deletePressed = true));

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deletePressed, true);
  });
}
