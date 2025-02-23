import 'package:flutter/material.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/controller/controller.dart';
import 'package:home_asset_management/core/controller/controller_injector.dart';
import 'package:home_asset_management/core/controller/controller_instance.dart';
import 'package:home_asset_management/core/widgets/toast/error.dart';
import 'package:home_asset_management/core/widgets/toast/success.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/create_home_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/delete_home_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/get_homes_use_case.dart';
import 'package:home_asset_management/modules/homes/domain/use_cases/update_home_use_case.dart';

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
  final CreateHomeUseCase _createHomeUseCase = CreateHomeUseCase.instance;
  final UpdateHomeUseCase _updateHomeUseCase = UpdateHomeUseCase.instance;
  final DeleteHomeUseCase _deleteHomeUseCase = DeleteHomeUseCase.instance;

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

  /// Adds a home to the database and sync the homes notifier.
  ///
  /// Uses optimistic addition to avoid showing a loading state when the home is
  /// being added.
  Future<HomeModel?> createHome({
    required String name,
    required String streetAddress1,
    required String streetAddress2,
    required String city,
    required UsState state,
    required String zip,
  }) async {
    final results = await _createHomeUseCase.execute(
      name: name,
      streetAddress1: streetAddress1,
      streetAddress2: streetAddress2,
      city: city,
      state: state,
      zip: zip,
    );

    // Handle failure case
    if (results.isLeft()) {
      final errorMessage = results.fold((failure) => failure.message, (_) => 'Unable to create home');
      ErrorToast(errorMessage).show();
      return null;
    }

    // Get the created home or return
    final newHome = results.getOrElse(() {
      throw Exception('Error adding home');
    });

    // Ensure notifier has a valid list before updating
    final List<HomeModel> updatedList = List.from(homesNotifier.value ?? []);
    updatedList.add(newHome);
    homesNotifier.value = updatedList; // Triggers UI update

    SuccessToast('Home added').show();
    return newHome;
  }

  /// Updates a home in the database and sync the homes notifier.
  ///
  /// Uses optimistic update to avoid showing a loading state when the home is
  /// being updated.
  Future<void> updateHome(HomeModel home) async {
    // Find the index of the home to update
    final index = homesNotifier.value?.indexWhere((h) => h.id == home.id);

    if (index == null || index == -1) return; // Ensure valid index

    // Create a new list to avoid modifying the original list reference
    final List<HomeModel> updatedList = List.from(homesNotifier.value ?? []);

    // Store the original home in case we need to revert
    final HomeModel temporaryHome = updatedList[index];

    // Apply early update in UI
    updatedList[index] = home;
    homesNotifier.value = [...updatedList]; // Triggers UI update

    // Perform the actual update operation
    final results = await _updateHomeUseCase.execute(home);

    if (results.isLeft()) {
      // If the update fails, revert back to the previous state
      updatedList[index] = temporaryHome;
      homesNotifier.value = [...updatedList]; // Assign new list reference

      final errorMessage = results.fold((failure) => failure.message, (_) => 'Unable to update home');
      ErrorToast(errorMessage).show();
      return;
    }

    // Success message
    SuccessToast('Home updated').show();
  }

  /// Deletes a home from the database and sync the homes notifier.
  ///
  /// Uses optimistic deletion to avoid showing a loading state when the home is
  /// being deleted.
  Future<void> deleteHome(String id) async {
    // Find the index of the home to delete
    final index = homesNotifier.value?.indexWhere((home) => home.id == id);

    if (index == null || index == -1) return; // Ensure the home exists before proceeding

    // Create a new list reference for proper UI updates
    final List<HomeModel> updatedList = List.from(homesNotifier.value ?? []);

    // Store the home in case we need to revert
    final HomeModel temporaryHome = updatedList[index];

    // Optimistic UI update: Remove home from list immediately
    updatedList.removeAt(index);
    homesNotifier.value = [...updatedList]; // Triggers UI update

    // Perform the actual delete operation
    final results = await _deleteHomeUseCase.execute(id);

    if (results.isLeft()) {
      // If deletion fails, revert back to previous state
      updatedList.insert(index, temporaryHome);
      homesNotifier.value = [...updatedList]; // Restore UI state

      final errorMessage = results.fold((failure) => failure.message, (_) => 'Unable to delete home');
      ErrorToast(errorMessage).show();
      return;
    }

    // Success message
    SuccessToast('Home deleted').show();
  }

  /// Disposes the homes notifier
  @override
  void onDispose() {
    homesNotifier.dispose();
    super.onDispose();
  }
}
