/// Basic status definition.
enum BasicStatus {
  /// Start from here.
  initial,

  /// Loading some data.
  loading,

  /// Load finished and succeed.
  success,

  /// Load finished and failed.
  failure;

  /// Is in loading state.
  ///
  /// Override this if added detail loading step.
  bool get isLoading => this == BasicStatus.loading;

  /// Successfully loaded or not.
  bool get isSucceed => this == BasicStatus.success;

  /// Is failed to load.
  bool get isFailed => this == BasicStatus.failure;
}
