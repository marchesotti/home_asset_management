import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart';
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart';
import 'package:home_asset_management/modules/assets/domain/repositories/assets_repository.dart';

/// A use case for getting the assets of a home.
class GetAssetsUseCase {
  final IAssetsRepository _assetsRepository;

  GetAssetsUseCase(this._assetsRepository);

  static GetAssetsUseCase get instance {
    return DependencyInjector.instance.get<GetAssetsUseCase>(
      ifNotRegistered: () => GetAssetsUseCaseInjection().inject(),
    );
  }

  /// Executes the get assets use case.
  ///
  /// Gets the assets of a given home.
  Future<Response<List<AssetModel>>> execute(String homeId) async {
    try {
      return await _assetsRepository.getHomeAssets(homeId);
    } catch (e) {
      return left(Failure(message: 'Unable to get home assets'));
    }
  }
}

class GetAssetsUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IAssetsRepository>(AssetsRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<GetAssetsUseCase>(() => GetAssetsUseCase(injector.get<IAssetsRepository>()));
  }
}
