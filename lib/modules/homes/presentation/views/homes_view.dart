import 'package:flutter/material.dart';
import 'package:home_asset_management/modules/homes/presentation/controllers/homes_controller.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/presentation/views/manage_home_view.dart';
import 'package:home_asset_management/modules/homes/presentation/widgets/home_tile.dart';

/// A view for displaying a list of homes.
class HomesView extends StatefulWidget {
  const HomesView({super.key});

  @override
  State<HomesView> createState() => _HomesViewState();
}

class _HomesViewState extends State<HomesView> {
  final HomesController homesController = HomesController.instance;

  @override
  void initState() {
    super.initState();
    homesController.fetchHomes();
  }

  @override
  void dispose() {
    homesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('Homes')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ValueListenableBuilder<List<HomeModel>?>(
            valueListenable: homesController.homesNotifier,
            builder: (context, homes, child) {
              if (homes == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (homes.isEmpty) {
                return const Center(child: Text('No homes found'));
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: homes.length,
                itemBuilder: (context, index) {
                  final home = homes[index];
                  return HomeTile(home);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageHomeView())),
        tooltip: 'Add home',
        child: const Icon(Icons.add),
      ),
    );
  }
}
