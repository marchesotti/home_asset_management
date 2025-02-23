import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/presentation/extensions/asset_type_enum_extension.dart';

/// A tile widget for an asset.
class AssetTile extends StatelessWidget {
  /// The asset type.
  final AssetTypeEnum asset;

  /// The callback function to be called when the tile is tapped.
  final VoidCallback? onTap;

  const AssetTile(this.asset, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(asset.icon), title: Text(asset.title), onTap: onTap);
  }
}
