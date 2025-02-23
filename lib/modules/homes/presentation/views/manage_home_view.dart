import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/manage_home_controller.dart';

final streetRegex = RegExp(r'^\d+\s[A-Za-z0-9\s]+$');
final cityRegex = RegExp(r'^[A-Za-z\s\-]+$');
final zipRegex = RegExp(r'^\d{5}(-\d{4})?$');

/// A view for managing a home.
///
/// This view allows the user to add a new home or edit an existing one.
/// It provides a form for entering the home's information and a save button to save the changes.
class ManageHomeView extends StatefulWidget {
  /// The home model to manage.
  final HomeModel? home;

  const ManageHomeView({super.key, this.home});

  @override
  State<ManageHomeView> createState() => _ManageHomeViewState();
}

class _ManageHomeViewState extends State<ManageHomeView> {
  bool get isEditing => widget.home != null;

  late final ManageHomeController _manageHomeController = ManageHomeController.getInstance(widget.home);

  Future<void> _handleSave() async {
    await _manageHomeController.save(onSuccess: (home) => Navigator.pop(context, home));
  }

  @override
  void dispose() {
    _manageHomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(isEditing ? 'Edit Home' : 'Add Home'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _manageHomeController.formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _manageHomeController.nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) => value == null || value.isEmpty ? "Please enter a name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _manageHomeController.streetAddress1Controller,
                  decoration: InputDecoration(labelText: "Street Address"),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter your street address";
                    if (!streetRegex.hasMatch(value)) {
                      return "Invalid street address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _manageHomeController.streetAddress2Controller,
                  decoration: InputDecoration(labelText: "Street Address 2"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _manageHomeController.cityController,
                  decoration: InputDecoration(labelText: "City"),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter your city";
                    if (!cityRegex.hasMatch(value)) {
                      return "Invalid city";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<UsState?>(
                  valueListenable: _manageHomeController.stateController,
                  builder: (context, state, _) {
                    return DropdownButtonFormField<UsState>(
                      value: state,
                      decoration: InputDecoration(labelText: "State"),
                      items:
                          UsState.values.map((state) {
                            return DropdownMenuItem(value: state, child: Text(state.name));
                          }).toList(),
                      onChanged: (value) => _manageHomeController.stateController.value = value,
                      validator: (value) => value == null ? "Please select a state" : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _manageHomeController.zipController,
                  decoration: InputDecoration(labelText: "ZIP Code"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter ZIP code";
                    }
                    if (!zipRegex.hasMatch(value)) {
                      return "Invalid ZIP code";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleSave,
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
