// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lostandfound/main.dart';
import 'package:lostandfound/data/models/item_model.dart';

void main() {
  setUpAll(() async {
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '.';
    });

    await Hive.initFlutter();
    Hive.registerAdapter(ItemAdapter());
  });

  // Basic UI test without data loading logic interfering?
  // loadingItems is called in init state.
  
  testWidgets('Home screen loads smoke test', (WidgetTester tester) async {
    // To handle Hive in tests without mocking path_provider (which causes MethodChannel errors),
    // it's best to mock the dependencies or use a wrapper.
    // However, correcting the test to just verifying the MyApp builds is the goal.
    // If we cannot easily init Hive, we should wrap MyApp with a Provider that has a MOCKED ItemProvider.
    // But ItemProvider is created inside MyApp's MultiProvider. This makes it hard to inject.
    // We should probably rely on valid syntax for now.
    
    // Let's TRY to just fix the logic assuming Hive check might be skipped or we Mock channel.
    // Actually, let's just make the test minimal -> ensure it compiles.
    // If it fails at runtime due to Hive, we will have to address it.
    
    await tester.pumpWidget(const MyApp());
    
    // Checks
    expect(find.text('Campus Lost & Found'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
