import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/domain/repositories/homes_repository.dart';

/// A use case for getting homes.
class GetHomesUseCase {
  final IHomesRepository _homesRepository;

  GetHomesUseCase(this._homesRepository);

  static GetHomesUseCase get instance {
    return DependencyInjector.instance.get<GetHomesUseCase>(ifNotRegistered: () => GetHomesUseCaseInjection().inject());
  }

  /// Executes the get homes use case.
  Future<Response<List<HomeModel>>> execute() async {
    try {
      return await _homesRepository.getHomes();
    } catch (e) {
      return left(Failure(message: 'Unable to get homes'));
    }
  }
}

class GetHomesUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IHomesRepository>(HomesRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<GetHomesUseCase>(() => GetHomesUseCase(injector.get<IHomesRepository>()));
  }
}
