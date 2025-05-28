import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'usecase.freezed.dart';

/// A generic use case mixin
mixin UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

@freezed
class NoParams with _$NoParams {}
