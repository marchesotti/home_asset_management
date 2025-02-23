import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/presentation/widgets/asset_tile.dart';

Widget createWidgetUnderTest(AssetTypeEnum asset, {VoidCallback? onTap, VoidCallback? onDeleteTap}) {
  return MaterialApp(home: Scaffold(body: AssetTile(asset, onTap: onTap, onDeleteTap: onDeleteTap)));
}

void main() {
  late AssetTypeEnum testAsset;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    testAsset = AssetTypeEnum.refrigerator;
  });

  testWidgets('AssetTile displays asset information correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testAsset));

    expect(find.text('Refrigerator'), findsOneWidget);
    expect(find.byIcon(Icons.kitchen), findsOneWidget);
  });

  testWidgets('AssetTile calls onTap when tapped', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(createWidgetUnderTest(testAsset, onTap: () => tapped = true));

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(tapped, true);
  });

  testWidgets('AssetTile shows menu when menu button is tapped and onDeleteTap is provided', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testAsset, onDeleteTap: () {}));

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('AssetTile does not show menu button when onDeleteTap is null', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testAsset));

    expect(find.byIcon(Icons.more_horiz), findsNothing);
  });

  testWidgets('AssetTile calls onDeleteTap when delete is pressed', (tester) async {
    bool deletePressed = false;

    await tester.pumpWidget(createWidgetUnderTest(testAsset, onDeleteTap: () => deletePressed = true));

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deletePressed, true);
  });

  testWidgets('AssetTile shows correct icon and title for different asset types', (tester) async {
    final testCases = [
      (AssetTypeEnum.airConditioner, 'Air Conditioner', Icons.air),
      (AssetTypeEnum.hvacSystem, 'HVAC System', Icons.thermostat),
      (AssetTypeEnum.solarPanel, 'Solar Panel', Icons.solar_power),
      (AssetTypeEnum.evCharger, 'EV Charger', Icons.electric_car),
      (AssetTypeEnum.battery, 'Battery', Icons.battery_charging_full),
    ];

    for (final testCase in testCases) {
      await tester.pumpWidget(createWidgetUnderTest(testCase.$1));

      expect(find.text(testCase.$2), findsOneWidget);
      expect(find.byIcon(testCase.$3), findsOneWidget);
    }
  });
}
