import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/repositories/assets_repository.dart';

/// A use case for deleting an asset from a home.
class DeleteHomeAssetUseCase {
  final IAssetsRepository _assetsRepository;

  DeleteHomeAssetUseCase(this._assetsRepository);

  static DeleteHomeAssetUseCase get instance {
    return DependencyInjector.instance.get<DeleteHomeAssetUseCase>(
      ifNotRegistered: () => DeleteHomeAssetUseCaseInjection().inject(),
    );
  }

  /// Executes the delete home asset use case.
  ///
  /// Deletes the given asset from the home.
  Future<Response<void>> execute(String assetId) async {
    try {
      return await _assetsRepository.deleteHomeAsset(assetId);
    } catch (e) {
      return left(Failure(message: 'Unable to delete home asset'));
    }
  }
}

class DeleteHomeAssetUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IAssetsRepository>(AssetsRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<DeleteHomeAssetUseCase>(() => DeleteHomeAssetUseCase(injector.get<IAssetsRepository>()));
  }
}
