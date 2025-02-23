import 'package:home_asset_management/core/di/injector.dart';

/// A base class for use case injections.
abstract class IUseCaseInjection {
  /// The injector instance.
  final DependencyInjector injector = DependencyInjector.instance;

  /// Injects the repositories and use case.
  void inject() {
    injectRepositories();
    injectUseCase();
  }

  /// Injects the repositories.
  void injectRepositories();

  /// Injects the use case.
  void injectUseCase();
}
