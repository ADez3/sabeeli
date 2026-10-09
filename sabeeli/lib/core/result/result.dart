import '../error/failures.dart';

/// The outcome of a repository or use-case call: a value, or the [Failure] explaining
/// why there is none.
///
/// Written in-house instead of depending on fpdart or dartz. The app only ever needed
/// `Either<Failure, T>` with `fold`, and a Dart 3 sealed class gives that plus
/// exhaustive `switch` without a functional-programming library.
sealed class Result<T> {
  const Result();

  bool get isOk => this is Ok<T>;

  /// The value, or null when this is an [Err].
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  /// Runs [onErr] or [onOk] depending on the outcome. Same argument order as
  /// `Either.fold`, failure first.
  R fold<R>(R Function(Failure failure) onErr, R Function(T value) onOk) =>
      switch (this) {
        Ok<T>(:final value) => onOk(value),
        Err<T>(:final failure) => onErr(failure),
      };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T>(:final value) => Ok(transform(value)),
    Err<T>(:final failure) => Err(failure),
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
