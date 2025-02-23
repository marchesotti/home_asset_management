import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/domain/repositories/homes_repository.dart';

/// A use case for updating a home.
class UpdateHomeUseCase {
  final IHomesRepository _homesRepository;

  UpdateHomeUseCase(this._homesRepository);

  static UpdateHomeUseCase get instance {
    return DependencyInjector.instance.get<UpdateHomeUseCase>(
      ifNotRegistered: () => UpdateHomeUseCaseInjection().inject(),
    );
  }

  /// Executes the update home use case.
  Future<Response<void>> execute(HomeModel home) async {
    try {
      return _homesRepository.updateHome(home);
    } catch (e) {
      return left(Failure(message: 'Unable to update home'));
    }
  }
}

class UpdateHomeUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IHomesRepository>(HomesRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<UpdateHomeUseCase>(() => UpdateHomeUseCase(injector.get<IHomesRepository>()));
  }
}
