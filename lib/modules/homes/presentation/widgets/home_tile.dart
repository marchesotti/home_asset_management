import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';

/// A tile widget that displays a home's information and provides a menu for managing it.
class HomeTile extends StatelessWidget {
  /// The home model to display.
  final HomeModel home;

  const HomeTile(this.home, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(home.name),
      subtitle: Text(home.address.toString()),
      onTap: () {
        // TODO: Route to home view
      },
    );
  }
}
