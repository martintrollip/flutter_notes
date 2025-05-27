import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  /// Indicates a failure due to server or network issues
  const factory Failure.serverFailure({
    @Default('A server error occurred.') String message,
  }) = ServerFailure;

  /// Indicates a failure related to local caching
  const factory Failure.cacheFailure({
    @Default('A cache error occurred.') String message,
  }) = CacheFailure;

  /// A general failure type for other unspecific errors
  const factory Failure.generalFailure({
    @Default('An unexpected error occurred.') String message,
  }) = GeneralFailure;
}
