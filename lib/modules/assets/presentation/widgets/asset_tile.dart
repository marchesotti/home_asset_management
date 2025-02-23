import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/presentation/extensions/asset_type_enum_extension.dart';

/// A tile widget for an asset.
class AssetTile extends StatelessWidget {
  /// The asset type.
  final AssetTypeEnum asset;

  /// The callback function to be called when the tile is tapped.
  final VoidCallback? onTap;

  /// The callback function to be called when the delete button is pressed.
  final VoidCallback? onDeleteTap;

  const AssetTile(this.asset, {super.key, this.onTap, this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(asset.icon),
      title: Text(asset.title),
      onTap: onTap,
      trailing:
          onDeleteTap != null
              ? MenuAnchor(
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
                    onPressed: onDeleteTap,
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : null,
    );
  }
}
