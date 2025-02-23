import 'package:flutter/material.dart';
import 'package:home_asset_management/core/controller/controller.dart';
import 'package:home_asset_management/core/controller/controller_injector.dart';
import 'package:home_asset_management/core/controller/controller_instance.dart';
import 'package:home_asset_management/core/widgets/toast/error.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/get_homes_use_case.dart';

/// A singleton controller that manages the homes, by fetching homes from the database and
/// providing the ability to add homes.
class HomesController extends Controller {
  HomesController._();

  @override
  ControllerInstanceInjector<HomesController> get injector {
    return ControllerInstanceInjector<HomesController>(this);
  }

  /// The instance of the homes controller.
  static HomesController get instance => ControllerInstance.of<HomesController>(() => HomesController._());

  /// Instances of the use cases.
  final GetHomesUseCase _getHomesUseCase = GetHomesUseCase.instance;

  /// The homes notifier represents the homes fetched from the database provided
  /// to the UI.
  ///
  /// Value starts null, indicating that the homes are not yet fetched. When the
  /// homes are fetched, the value is set to the list of homes.
  final ValueNotifier<List<HomeModel>?> homesNotifier = ValueNotifier<List<HomeModel>?>(null);

  /// Fetches the homes from the database and sets the homes notifier to the
  /// homes fetched from the database.
  Future<void> fetchHomes() async {
    final results = await _getHomesUseCase.execute();

    if (results.isLeft()) {
      homesNotifier.value = [];
      final errorMessage = results.fold((failure) => failure.message, (_) => 'Unable to get homes');
      ErrorToast(errorMessage).show();
      return;
    }

    homesNotifier.value = results.getOrElse(() => []);
  }

  /// Disposes the homes notifier
  @override
  void onDispose() {
    homesNotifier.dispose();
    super.onDispose();
  }
}
