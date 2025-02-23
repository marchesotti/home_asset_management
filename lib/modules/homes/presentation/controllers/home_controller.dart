import 'package:flutter/material.dart';
import 'package:home_asset_management/core/controller/controller.dart';
import 'package:home_asset_management/core/controller/controller_injector.dart';
import 'package:home_asset_management/core/controller/controller_instance.dart';
import 'package:home_asset_management/core/widgets/toast/error.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/get_home_assets_use_case.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

/// A controller for managing a home.
///
/// This controller provides functionality for fetching assets from the database
/// and creating and deleting assets.
class HomeController extends Controller {
  /// The home model to manage.
  final HomeModel home;

  HomeController._(this.home);

  @override
  ControllerInstanceInjector<HomeController> get injector => ControllerInstanceInjector(this, home.id);

  /// The instance of the home controller.
  static HomeController getInstance(HomeModel home) {
    return ControllerInstance.of(() => HomeController._(home), home.id);
  }

  /// Instances of the use cases.
  final GetAssetsUseCase _getAssetsUseCase = GetAssetsUseCase.instance;

  /// The home notifier represents the home fetched from the database provided
  /// to the UI.
  ///
  /// Value starts null, indicating that the home is not yet fetched. When the
  /// home is fetched, the value is set to the home.
  late final ValueNotifier<HomeModel> homeNotifier = ValueNotifier(home);

  /// The assets notifier represents the assets fetched from the database provided
  /// to the UI.
  ///
  /// Value starts null, indicating that the assets are not yet fetched. When the
  /// assets are fetched, the value is set to the list of assets.
  final ValueNotifier<List<AssetModel>?> assetsNotifier = ValueNotifier<List<AssetModel>?>(null);

  /// Fetches the homes from the database and sets the homes notifier to the
  /// homes fetched from the database.
  Future<void> fetchAssets() async {
    final results = await _getAssetsUseCase.execute(home.id);

    if (results.isLeft()) {
      assetsNotifier.value = [];
      ErrorToast('Error fetching assets').show();
      return;
    }

    assetsNotifier.value = results.getOrElse(() => []);
  }
}
