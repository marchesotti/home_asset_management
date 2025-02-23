import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_asset_management/core/controller/controller.dart';
import 'package:home_asset_management/core/controller/controller_injector.dart';
import 'package:home_asset_management/core/controller/controller_instance.dart';
import 'package:home_asset_management/core/widgets/toast/error.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/domain/use_cases/search_assets_use_case.dart';

/// A controller for searching for an asset.
class SearchAssetController extends Controller {
  SearchAssetController._();

  @override
  ControllerInstanceInjector<SearchAssetController> get injector => ControllerInstanceInjector(this);

  /// Instance of the search asset controller.
  static SearchAssetController getInstance() {
    return ControllerInstance.of(() => SearchAssetController._());
  }

  /// The use case for searching for assets.
  final SearchAssetsUseCase _searchAssetsUseCase = SearchAssetsUseCase.instance;

  /// The debounce timer for the search controller.
  Timer? debounceTimer;

  /// The notifier for the search controller.
  final ValueNotifier<bool> isSearchingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<List<AssetTypeEnum>> assetsNotifier = ValueNotifier<List<AssetTypeEnum>>([]);
  final TextEditingController searchController = TextEditingController();

  /// The onChanged method for the search controller.
  ///
  /// Debounces the search query and searches for the assets. The debounce time is 500 milliseconds.
  void onChanged(String query) {
    // Check if the timer is already running. If so, cancel it
    if (debounceTimer != null) debounceTimer?.cancel();

    // Set the isSearchingNotifier to true, so the UI can show a loading indicator
    isSearchingNotifier.value = true;

    // Set the debounce timer to search for the assets after 500 milliseconds
    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _searchAssets(query);
      isSearchingNotifier.value = false;
    });
  }

  /// Searches for the assets.
  ///
  /// Searches for the assets using the search assets use case based on the query.
  Future<void> _searchAssets(String query) async {
    if (query.isEmpty) {
      assetsNotifier.value = [];
      return;
    }

    final results = await _searchAssetsUseCase.execute(query);

    if (results.isLeft()) {
      assetsNotifier.value = [];
      final errorMessage = results.fold((failure) => failure.message, (_) => 'Unable to search assets');
      ErrorToast(errorMessage).show();
      return;
    }

    assetsNotifier.value = results.getOrElse(() => []);
  }

  /// Disposes of the search asset controller.
  @override
  void onDispose() {
    debounceTimer?.cancel();
    isSearchingNotifier.dispose();
    searchController.dispose();
    assetsNotifier.dispose();
    super.onDispose();
  }
}
