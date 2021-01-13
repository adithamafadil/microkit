part of 'movies_bloc.dart';

@freezed
abstract class MoviesState with _$MoviesState {
  const factory MoviesState({
    @required MovieResult movieResult,
    @required InteractorState state,
    @required ButtonStates buttonState,
  }) = _MovieState;

  factory MoviesState.initial() => const MoviesState(
        movieResult: MovieResult(message: 'No Data', results: []),
        state: InteractorState.loading(),
        buttonState: ButtonStates.standby,
      );
}
