import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/core.dart';

/// A generic use case mixin
mixin UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
