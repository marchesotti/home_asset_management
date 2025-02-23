// Mocks generated by Mockito 5.4.5 from annotations
// in home_asset_management/test/modules/homes/presentation/views/home_view_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:home_asset_management/core/consts/us_states.dart' as _i7;
import 'package:home_asset_management/core/errors/failure.dart' as _i5;
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart'
    as _i10;
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart'
    as _i9;
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart'
    as _i8;
import 'package:home_asset_management/modules/homes/data/models/home_model.dart'
    as _i6;
import 'package:home_asset_management/modules/homes/data/repositories/i_homes_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IHomesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIHomesRepository extends _i1.Mock implements _i3.IHomesRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.HomeModel>>> getHomes() =>
      (super.noSuchMethod(
        Invocation.method(
          #getHomes,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.HomeModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.HomeModel>>(
          this,
          Invocation.method(
            #getHomes,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.HomeModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.HomeModel>>(
          this,
          Invocation.method(
            #getHomes,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.HomeModel>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.HomeModel>> createHome({
    required String? name,
    required String? streetAddress1,
    required String? streetAddress2,
    required String? city,
    required _i7.UsState? state,
    required String? zip,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createHome,
          [],
          {
            #name: name,
            #streetAddress1: streetAddress1,
            #streetAddress2: streetAddress2,
            #city: city,
            #state: state,
            #zip: zip,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.HomeModel>>.value(
            _FakeEither_0<_i5.Failure, _i6.HomeModel>(
          this,
          Invocation.method(
            #createHome,
            [],
            {
              #name: name,
              #streetAddress1: streetAddress1,
              #streetAddress2: streetAddress2,
              #city: city,
              #state: state,
              #zip: zip,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.HomeModel>>.value(
                _FakeEither_0<_i5.Failure, _i6.HomeModel>(
          this,
          Invocation.method(
            #createHome,
            [],
            {
              #name: name,
              #streetAddress1: streetAddress1,
              #streetAddress2: streetAddress2,
              #city: city,
              #state: state,
              #zip: zip,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.HomeModel>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> updateHome(_i6.HomeModel? home) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateHome,
          [home],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #updateHome,
            [home],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, void>>.value(
                _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #updateHome,
            [home],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> deleteHome(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteHome,
          [id],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #deleteHome,
            [id],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, void>>.value(
                _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #deleteHome,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);
}

/// A class which mocks [IAssetsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIAssetsRepository extends _i1.Mock implements _i8.IAssetsRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i9.AssetModel>>> getHomeAssets(
          String? homeId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getHomeAssets,
          [homeId],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i9.AssetModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i9.AssetModel>>(
          this,
          Invocation.method(
            #getHomeAssets,
            [homeId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i9.AssetModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i9.AssetModel>>(
          this,
          Invocation.method(
            #getHomeAssets,
            [homeId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i9.AssetModel>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i9.AssetModel>> createHomeAsset({
    required String? homeId,
    required String? name,
    required _i10.AssetTypeEnum? type,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createHomeAsset,
          [],
          {
            #homeId: homeId,
            #name: name,
            #type: type,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i9.AssetModel>>.value(
            _FakeEither_0<_i5.Failure, _i9.AssetModel>(
          this,
          Invocation.method(
            #createHomeAsset,
            [],
            {
              #homeId: homeId,
              #name: name,
              #type: type,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i9.AssetModel>>.value(
                _FakeEither_0<_i5.Failure, _i9.AssetModel>(
          this,
          Invocation.method(
            #createHomeAsset,
            [],
            {
              #homeId: homeId,
              #name: name,
              #type: type,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i9.AssetModel>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> deleteHomeAsset(String? assetId) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteHomeAsset,
          [assetId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #deleteHomeAsset,
            [assetId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, void>>.value(
                _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #deleteHomeAsset,
            [assetId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);
}
