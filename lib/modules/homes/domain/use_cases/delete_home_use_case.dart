import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/di/injector.dart';
import 'package:home_asset_management/core/entities/response.dart';
import 'package:home_asset_management/core/errors/failure.dart';
import 'package:home_asset_management/core/use-case/use_case_injection.dart';
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart';
import 'package:home_asset_management/modules/homes/domain/repositories/homes_repository.dart';

/// A use case for deleting a home.
class DeleteHomeUseCase {
  final IHomesRepository _homesRepository;

  DeleteHomeUseCase(this._homesRepository);

  static DeleteHomeUseCase get instance {
    return DependencyInjector.instance.get<DeleteHomeUseCase>(
      ifNotRegistered: () => DeleteHomeUseCaseInjection().inject(),
    );
  }

  /// Executes the delete home use case.
  Future<Response<void>> execute(String id) async {
    try {
      return _homesRepository.deleteHome(id);
    } catch (e) {
      return left(Failure(message: 'Unable to delete home'));
    }
  }
}

class DeleteHomeUseCaseInjection extends IUseCaseInjection {
  @override
  void injectRepositories() {
    injector.injectSingleton<IHomesRepository>(HomesRepository.new);
  }

  @override
  void injectUseCase() {
    injector.injectSingleton<DeleteHomeUseCase>(() => DeleteHomeUseCase(injector.get<IHomesRepository>()));
  }
}
