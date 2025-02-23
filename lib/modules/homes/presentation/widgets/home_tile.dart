import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/views/home_view.dart';
import 'package:home_asset_management/modules/homes/presentation/views/manage_home_view.dart';

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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView(home))),
      trailing: MenuAnchor(
        builder: (BuildContext context, MenuController controller, Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_horiz),
            tooltip: 'Show menu',
          );
        },
        menuChildren: [
          MenuItemButton(
            onPressed:
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageHomeView(home: home))),
            child: Row(children: [const Icon(Icons.edit), const SizedBox(width: 8), Text('Edit')]),
          ),
          // TODO: Add delete button
        ],
      ),
    );
  }
}
