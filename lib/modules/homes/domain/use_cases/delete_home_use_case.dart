import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/repositories/assets_repository.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/domain/repositories/homes_repository.dart';

/// A use case for deleting a home.
class DeleteHomeUseCase {
  final IHomesRepository _homesRepository;
  final IAssetsRepository _assetsRepository;

  DeleteHomeUseCase(this._homesRepository, this._assetsRepository);

  static DeleteHomeUseCase get instance {
    return DependencyInjector.instance.get<DeleteHomeUseCase>(
      ifNotRegistered: () => DeleteHomeUseCaseInjection().inject(),
    );
  }

  /// Executes the delete home use case.
  Future<Response<void>> execute(String id) async {
    try {
      final deleteHomeResult = await _homesRepository.deleteHome(id);
      if (deleteHomeResult.isLeft()) {
        return deleteHomeResult;
      }
      final homeAssetsResults = await _assetsRepository.getHomeAssets(id);
      if (homeAssetsResults.isLeft()) {
        return homeAssetsResults;
      }
      final homeAssets = homeAssetsResults.fold((failure) => [], (assets) => assets);
      for (final asset in homeAssets) {
        final deleteAssetResult = await _assetsRepository.deleteHomeAsset(asset.id);
        if (deleteAssetResult.isLeft()) {
          return deleteAssetResult;
        }
      }
      return right(null);
    } catch (e) {
      return left(Failure(message: 'Unable to delete home'));
    }
  }
}

class DeleteHomeUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IHomesRepository>(HomesRepository.new);
    injector.injectSingleton<IAssetsRepository>(AssetsRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<DeleteHomeUseCase>(
      () => DeleteHomeUseCase(injector.get<IHomesRepository>(), injector.get<IAssetsRepository>()),
    );
  }
}
