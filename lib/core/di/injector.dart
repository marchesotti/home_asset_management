import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// A class for dependency injection.
class DependencyInjector {
  DependencyInjector._();

  /// The instance of the dependency injector.
  static final DependencyInjector _instance = DependencyInjector._();

  /// The instance of the dependency injector.
  static DependencyInjector get instance => _instance;

  /// Gets an instance of a type.
  T get<T extends Object>({VoidCallback? ifNotRegistered, String? instanceName}) {
    if (!GetIt.I.isRegistered<T>()) {
      ifNotRegistered?.call();
    }
    return GetIt.I.get<T>(instanceName: instanceName);
  }

  /// Injects a singleton instance of a type.
  void injectSingleton<T extends Object>(T Function() factory, [String? instanceName]) {
    if (GetIt.I.isRegistered<T>(instanceName: instanceName)) return;
    GetIt.I.registerLazySingleton(factory, instanceName: instanceName);
  }

  /// Unregisters an instance of a type.
  void unregister<T extends Object>(T instance, [String? instanceName]) {
    if (!GetIt.I.isRegistered<T>(instanceName: instanceName)) return;
    GetIt.I.unregister<T>(instance: instance, instanceName: instanceName);
  }

  /// Resets a singleton instance of a type.
  void reset<T extends Object>(T instance, [String? instanceName]) {
    if (!GetIt.I.isRegistered<T>(instanceName: instanceName)) return;
    GetIt.I.resetLazySingleton<T>(instance: instance, instanceName: instanceName);
  }

  void resetAll() {
    GetIt.I.reset();
  }
}
