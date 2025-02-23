import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/consts/us_states.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/data/models/home_model.dart';
import 'package:home_asset_management/modules/homes/domain/repositories/homes_repository.dart';

/// A use case for creating a home.
class CreateHomeUseCase {
  final IHomesRepository _homesRepository;

  CreateHomeUseCase(this._homesRepository);

  static CreateHomeUseCase get instance {
    return DependencyInjector.instance.get<CreateHomeUseCase>(
      ifNotRegistered: () => CreateHomeUseCaseInjection().inject(),
    );
  }

  /// Executes the create home use case.
  Future<Response<HomeModel>> execute({
    required String name,
    required String streetAddress1,
    required String streetAddress2,
    required String city,
    required UsState state,
    required String zip,
  }) async {
    try {
      return _homesRepository.createHome(
        name: name,
        streetAddress1: streetAddress1,
        streetAddress2: streetAddress2,
        city: city,
        state: state,
        zip: zip,
      );
    } catch (e) {
      return left(Failure(message: 'Unable to create home'));
    }
  }
}

class CreateHomeUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IHomesRepository>(HomesRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<CreateHomeUseCase>(() => CreateHomeUseCase(injector.get<IHomesRepository>()));
  }
}
