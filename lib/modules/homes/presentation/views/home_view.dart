import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/presentation/widgets/asset_tile.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/home_controller.dart';
import 'package:home_asset_management/modules/homes/presentation/views/manage_home_view.dart';

/// A view for displaying a home's information and assets attached to it.
class HomeView extends StatefulWidget {
  /// The home model to display.
  final HomeModel home;

  const HomeView(this.home, {super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController _homeController = HomeController.getInstance(widget.home);

  /// Handles the edit home button.
  ///
  /// Navigates to the manage home view and updates the home controller with
  /// the updated home.
  Future<void> _handleEditHome() async {
    // Get the updated home from the manage home view
    final updatedHome = await Navigator.push<HomeModel?>(
      context,
      MaterialPageRoute(builder: (context) => ManageHomeView(home: widget.home)),
    );
    if (updatedHome == null) return;

    // Update the home controller with the updated home
    _homeController.homeNotifier.value = updatedHome;
  }

  @override
  void initState() {
    super.initState();
    _homeController.fetchAssets();
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeModel>(
      valueListenable: _homeController.homeNotifier,
      builder: (context, home, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(home.name),
            bottom: PreferredSize(preferredSize: Size.zero, child: Text(home.address.toString())),
            actions: [IconButton(onPressed: _handleEditHome, icon: const Icon(Icons.edit))],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ValueListenableBuilder<List<AssetModel>?>(
                valueListenable: _homeController.assetsNotifier,
                builder: (context, assets, child) {
                  if (assets == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (assets.isEmpty) {
                    return const Center(child: Text('No assets found'));
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];
                      return AssetTile(asset.type);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
