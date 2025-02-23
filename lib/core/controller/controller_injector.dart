import 'package:home_asset_management/core/di/injector.dart';

/// A class for controller instance injector.
class ControllerInstanceInjector<T extends Object> {
  /// The id of the controller.
  final String? _id;

  /// The instance of the controller.
  final T _instance;

  ControllerInstanceInjector(this._instance, [this._id]);

  /// Injects the controller.
  void inject() {
    DependencyInjector.instance.injectSingleton<T>(() => _instance, _id);
  }

  /// Disposes of the controller.
  void dispose() {
    DependencyInjector.instance.unregister<T>(_instance, _id);
  }
}
