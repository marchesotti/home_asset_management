// Mocks generated by Mockito 5.4.5 from annotations
// in home_asset_management/test/modules/assets/domain/use_cases/get_home_assets_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:home_asset_management/core/errors/failure.dart' as _i5;
import 'package:home_asset_management/modules/assets/data/enums/asset_type_enum.dart'
    as _i7;
import 'package:home_asset_management/modules/assets/data/model/asset_model.dart'
    as _i6;
import 'package:home_asset_management/modules/assets/data/repositories/i_assets_repository.dart'
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

/// A class which mocks [IAssetsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIAssetsRepository extends _i1.Mock implements _i3.IAssetsRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.AssetModel>>> getHomeAssets(
          String? homeId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getHomeAssets,
          [homeId],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.AssetModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.AssetModel>>(
          this,
          Invocation.method(
            #getHomeAssets,
            [homeId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.AssetModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.AssetModel>>(
          this,
          Invocation.method(
            #getHomeAssets,
            [homeId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.AssetModel>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.AssetModel>> createHomeAsset({
    required String? homeId,
    required String? name,
    required _i7.AssetTypeEnum? type,
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
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.AssetModel>>.value(
            _FakeEither_0<_i5.Failure, _i6.AssetModel>(
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
            _i4.Future<_i2.Either<_i5.Failure, _i6.AssetModel>>.value(
                _FakeEither_0<_i5.Failure, _i6.AssetModel>(
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
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.AssetModel>>);

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
