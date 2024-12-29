import 'package:flutter/foundation.dart';

sealed class Result<T> {
  const Result();
  factory Result.success(T value) = Success<T>;
  factory Result.failure(Error error, [StackTrace? stackTrace]) = Failure<T>;
  factory Result.loading(Listenable progress) = Loading<T>;

  Future<Result<U>> map<U>(Future<U> Function(T value) transform)
  async => switch (this) {
    Success(:final value) => _transform(value, transform),
    Failure(:final error, :final stackTrace) => Result.failure(error, stackTrace),
    Loading(:final progress) => Result.loading(progress),
  };

  Future<Result<U>> _transform<U>(T value, Future<U> Function(T value) transform) async {
    try {
      return Result.success(await transform(value));
    } catch (e, stackTrace) {
      return e is Error
          ? Result.failure(e, stackTrace)
          : Result.failure(StateError('Non-Error exception'), stackTrace);
    }
  }
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}
class Failure<T> extends Result<T> {
  const Failure(this.error, [this.stackTrace]);
  final Error error;
  final StackTrace? stackTrace;
  Result<U> copy<U>() => Result.failure(error, stackTrace);
}
class Loading<T> extends Result<T> {
  const Loading(this.progress);
  final Listenable progress;
  Result<U> copy<U>() => Result.loading(progress);
}

extension FutureResultExtension<T> on Future<Result<T>> {
  Future<Result<U>> map<U>(Future<U> Function(T value) transform)
  async => (await this).map(transform);
}