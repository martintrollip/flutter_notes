import 'package:equatable/equatable.dart';

/// Represents a base class for all failure types in the application
abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Indicates a failure due to server or network issues
class ServerFailure extends Failure {
  const ServerFailure({String? message})
    : super(message: message ?? 'A server error occurred.');
}

/// Indicates a failure related to local caching
class CacheFailure extends Failure {
  const CacheFailure({String? message})
    : super(message: message ?? 'A cache error occurred.');
}

/// A general failure type for other unspecific errors
class GeneralFailure extends Failure {
  const GeneralFailure({String? message})
    : super(message: message ?? 'An unexpected error occurred.');
}
