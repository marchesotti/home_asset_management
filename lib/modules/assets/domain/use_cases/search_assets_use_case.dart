import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart';
import 'package:home_asset_management/modules/assets/presentation/extensions/asset_type_enum_extension.dart';

/// A use case for searching for assets.
class SearchAssetsUseCase {
  SearchAssetsUseCase();

  static SearchAssetsUseCase get instance {
    return DependencyInjector.instance.get<SearchAssetsUseCase>(
      ifNotRegistered: () => SearchAssetsUseCaseInjection().inject(),
    );
  }

  /// Executes the search assets use case.
  ///
  /// Searches for the assets using the search assets use case based on the query.
  Future<Response<List<AssetTypeEnum>>> execute(String query) async {
    try {
      final results =
          AssetTypeEnum.values
              .where(
                (element) =>
                    element.name.toLowerCase().contains(query.toLowerCase()) ||
                    element.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      return right(results);
    } catch (e) {
      return left(Failure(message: 'Unable to search assets'));
    }
  }
}

class SearchAssetsUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {}

  @override
  void injectUseCase() {
    injector.injectSingleton<SearchAssetsUseCase>(() => SearchAssetsUseCase());
  }
}
