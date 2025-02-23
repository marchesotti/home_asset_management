import 'package:dartz/dartz.dart';
import 'package:home_asset_management/core/errors/failure.dart';

/// A type for a response.
typedef Response<T> = Either<Failure, T>;
