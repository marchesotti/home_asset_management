import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:home_asset_management/core/di/injector.dart';

void main() {
  group('DependencyInjector', () {
    late DependencyInjector injector;

    setUp(() {
      GetIt.I.reset();
      injector = DependencyInjector.instance;
    });

    tearDown(() {
      injector.resetAll();
    });

    test('instance should be singleton', () {
      final instance1 = DependencyInjector.instance;
      final instance2 = DependencyInjector.instance;
      expect(identical(instance1, instance2), true);
    });

    group('injectSingleton', () {
      test('should register a singleton', () {
        injector.injectSingleton(() => 'test');
        expect(injector.get<String>(), 'test');
      });

      test('should not register duplicate singleton', () {
        injector.injectSingleton(() => 'test1');
        injector.injectSingleton(() => 'test2');
        expect(injector.get<String>(), 'test1');
      });

      test('should register named singleton', () {
        injector.injectSingleton(() => 'test1', 'name1');
        injector.injectSingleton(() => 'test2', 'name2');
        expect(injector.get<String>(instanceName: 'name1'), 'test1');
        expect(injector.get<String>(instanceName: 'name2'), 'test2');
      });
    });

    group('get', () {
      test('should return registered instance', () {
        injector.injectSingleton(() => 42);
        expect(injector.get<int>(), 42);
      });

      test('should call ifNotRegistered callback when type not registered', () {
        var callbackCalled = false;
        expect(() => injector.get<int>(ifNotRegistered: () => callbackCalled = true), throwsStateError);
        expect(callbackCalled, true);
      });

      test('should throw when type not registered and no callback provided', () {
        expect(() => injector.get<int>(), throwsStateError);
      });
    });

    group('unregister', () {
      test('should unregister instance', () {
        injector.injectSingleton(() => 'test');
        final instance = injector.get<String>();
        injector.unregister<String>(instance);
        expect(() => injector.get<String>(), throwsStateError);
      });

      test('should not throw when unregistering non-existent instance', () {
        expect(() => injector.unregister<String>('test'), returnsNormally);
      });
    });

    group('reset', () {
      test('should reset singleton instance to use updated factory', () {
        // Create a mutable value to control the factory
        var value = 'test1';

        // Register a factory that uses the mutable value
        injector.injectSingleton(() => value);
        expect(injector.get<String>(), 'test1');

        // Get the instance and verify it's cached
        final instance = injector.get<String>();
        value = 'test2'; // Change the value
        expect(injector.get<String>(), 'test1'); // Should still return cached value

        // Reset the singleton
        injector.reset<String>(instance);

        // Should now use the new value from the factory
        expect(injector.get<String>(), 'test2');
      });

      test('should not throw when resetting non-existent instance', () {
        expect(() => injector.reset<String>('test'), returnsNormally);
      });
    });
  });
}
