import 'package:fpdart/fpdart.dart';

/// Extension to access wrapped types in [Either].
extension AccessEither<L, R> on Either<L, R> {
  /// Get the right side value.
  ///
  /// Throw if is null.
  R unwrap() {
    return getRight().toNullable()!;
  }

  /// Get the left side value.
  ///
  /// Throw if is null.
  L unwrapErr() {
    return getLeft().toNullable()!;
  }
}
