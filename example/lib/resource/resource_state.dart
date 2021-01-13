import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource_state.freezed.dart';

@freezed
abstract class ResourceState<T> with _$ResourceState {
  const factory ResourceState.success([T data]) = _Success<T>;
  const factory ResourceState.error([T data]) = _Error<T>;
  const factory ResourceState.networkError([T data]) = _NetworkError<T>;
}
