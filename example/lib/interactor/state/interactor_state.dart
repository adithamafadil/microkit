import 'package:freezed_annotation/freezed_annotation.dart';

part 'interactor_state.freezed.dart';

@freezed
abstract class InteractorState with _$InteractorState {
  const factory InteractorState.loading() = _Loading;
  const factory InteractorState.success() = _Success;
  const factory InteractorState.error() = _Error;
  const factory InteractorState.networkError() = _NetworkError;
}
