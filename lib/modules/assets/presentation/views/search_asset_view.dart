import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/presentation/controllers/search_asset_controller.dart';
import 'package:home_asset_management/modules/assets/presentation/widgets/asset_tile.dart';

/// A view for searching for an asset.
class SearchAssetView extends StatefulWidget {
  const SearchAssetView({super.key});

  @override
  State<SearchAssetView> createState() => _SearchAssetViewState();
}

class _SearchAssetViewState extends State<SearchAssetView> {
  final SearchAssetController _searchAssetController = SearchAssetController.getInstance();

  /// Handles the selection of an asset.
  ///
  /// Navigates back to the previous screen with the selected asset.
  void handleSelectAsset(AssetTypeEnum asset) {
    Navigator.pop(context, asset);
  }

  /// Disposes of the search asset controller.
  @override
  void dispose() {
    _searchAssetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Asset')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchAssetController.searchController,
              decoration: InputDecoration(hintText: 'Search Asset'),
              onChanged: _searchAssetController.onChanged,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _searchAssetController.isSearchingNotifier,
              builder: (context, isSearching, child) {
                return ValueListenableBuilder<List<AssetTypeEnum>>(
                  valueListenable: _searchAssetController.assetsNotifier,
                  builder: (context, assets, child) {
                    if (isSearching) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (assets.isEmpty) {
                      return const Center(child: Text('No assets found'));
                    }
                    return ListView.builder(
                      itemCount: assets.length,
                      itemBuilder: (context, index) {
                        final asset = assets[index];
                        return AssetTile(asset, onTap: () => handleSelectAsset(asset));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
