import 'package:flutter/material.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/controller/controller.dart';
import 'package:home_asset_management/core/controller/controller_injector.dart';
import 'package:home_asset_management/core/controller/controller_instance.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/homes_controller.dart';

/// A controller for managing a home.
///
/// This controller provides functionality for creating and updating a home.
/// It also handles the validation of the form data.
class ManageHomeController extends Controller {
  /// The home model to manage.
  final HomeModel? home;

  ManageHomeController._(this.home);

  @override
  ControllerInstanceInjector<ManageHomeController> get injector => ControllerInstanceInjector(this, home?.id);

  /// The instance of the manage home controller.
  static ManageHomeController getInstance(HomeModel? home) {
    return ControllerInstance.of(() => ManageHomeController._(home), home?.id);
  }

  final HomesController _homesController = HomesController.instance;

  /// Whether the home is being edited.
  bool get isEditing => home != null;

  /// The form key for the home form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// The name controller for the home form.
  late final TextEditingController nameController = TextEditingController(text: home?.name);

  /// The street address 1 controller for the home form.
  late final TextEditingController streetAddress1Controller = TextEditingController(text: home?.address.streetAddress1);

  /// The street address 2 controller for the home form.
  late final TextEditingController streetAddress2Controller = TextEditingController(text: home?.address.streetAddress2);

  /// The city controller for the home form.
  late final TextEditingController cityController = TextEditingController(text: home?.address.city);

  /// The state controller for the home form.
  late final ValueNotifier<UsState?> stateController = ValueNotifier(home?.address.state);

  /// The zip controller for the home form.
  late final TextEditingController zipController = TextEditingController(text: home?.address.zip);

  /// Creates a new home.
  ///
  /// This method creates a new home using the homes controller and calls the onSuccess callback with the created home.
  Future<void> _create(void Function(HomeModel)? onSuccess) async {
    final createdHome = await _homesController.createHome(
      name: nameController.text,
      streetAddress1: streetAddress1Controller.text,
      streetAddress2: streetAddress2Controller.text,
      city: cityController.text,
      state: stateController.value!,
      zip: zipController.text,
    );
    if (createdHome == null) return;
    onSuccess?.call(createdHome);
  }

  /// Updates an existing home.
  ///
  /// This method updates an existing home using the homes controller and calls the onSuccess callback with the updated home.
  Future<void> _update(void Function(HomeModel)? onSuccess) async {
    final updatedHome = home!.copyWith(
      name: nameController.text,
      address: home!.address.copyWith(
        streetAddress1: streetAddress1Controller.text,
        streetAddress2: streetAddress2Controller.text,
        city: cityController.text,
        state: stateController.value,
        zip: zipController.text,
      ),
    );
    await _homesController.updateHome(updatedHome);
    onSuccess?.call(updatedHome);
  }

  /// Saves the home.
  ///
  /// This method validates the form data and saves the home.
  /// If the home is being edited, it updates the home.
  /// If the home is being created, it creates the home.
  /// It then calls the onSuccess callback with the saved home.
  Future<void> save({void Function(HomeModel)? onSuccess}) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    isEditing ? _update(onSuccess) : _create(onSuccess);
  }

  /// Disposes of the controllers.
  @override
  void onDispose() {
    nameController.dispose();
    streetAddress1Controller.dispose();
    streetAddress2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.onDispose();
  }
}
