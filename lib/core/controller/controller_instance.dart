import 'package:home_asset_management/core/controller/controller.dart';
import 'package:home_asset_management/core/di/injector.dart';

/// A class for controller instances.
class ControllerInstance {
  /// Gets an instance of a controller.
  static T of<T extends Controller>(T Function() factory, [String? id]) {
    return DependencyInjector.instance.get<T>(
      instanceName: id,
      ifNotRegistered: () {
        DependencyInjector.instance.injectSingleton<T>(factory, id);
      },
    );
  }
}
