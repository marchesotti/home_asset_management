import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:home_asset_management/core/controller/controller_injector.dart';

/// A base class for controllers.
abstract class Controller<T extends Object> with Disposable {
  /// Initializes the controller.
  Controller() {
    init();
  }

  /// The injector instance.
  ControllerInstanceInjector<T> get injector;

  /// Initializes the controller.
  @mustCallSuper
  void init() {
    injector.inject();
  }

  /// Disposes of the controller.
  @nonVirtual
  @mustCallSuper
  void dispose() {
    injector.dispose();
  }

  /// Method called when the controller is disposed.
  @override
  @mustCallSuper
  FutureOr onDispose() {}
}
