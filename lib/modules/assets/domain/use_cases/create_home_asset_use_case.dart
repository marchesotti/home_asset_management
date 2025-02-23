import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/repositories/assets_repository.dart';

/// A use case for creating a home asset.
class CreateHomeAssetUseCase {
  final IAssetsRepository _assetsRepository;

  CreateHomeAssetUseCase(this._assetsRepository);

  static CreateHomeAssetUseCase get instance {
    return DependencyInjector.instance.get<CreateHomeAssetUseCase>(
      ifNotRegistered: () => CreateHomeAssetUseCaseInjection().inject(),
    );
  }

  /// Executes the create home asset use case.
  ///
  /// Create a home asset based on the homeId and the asset type.
  Future<Response<AssetModel>> execute(String homeId, AssetTypeEnum assetType) async {
    try {
      return await _assetsRepository.createHomeAsset(homeId: homeId, name: assetType.name, type: assetType);
    } catch (e) {
      return left(Failure(message: 'Unable to create home asset'));
    }
  }
}

class CreateHomeAssetUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IAssetsRepository>(AssetsRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<CreateHomeAssetUseCase>(() => CreateHomeAssetUseCase(injector.get<IAssetsRepository>()));
  }
}
