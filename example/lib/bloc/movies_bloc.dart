import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:example/entities/movie_item_entity.dart';
import 'package:example/interactor/movie_interactor.dart';
import 'package:example/interactor/state/interactor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:microkit/progress_button/progress_button.dart';

part 'movies_event.dart';
part 'movies_state.dart';
part 'movies_bloc.freezed.dart';

@lazySingleton
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  GetMoviesInteractor _getMoviesInteractor;

  MoviesBloc(this._getMoviesInteractor) : super(MoviesState.initial());

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    yield* event.map(loadMovies: (e) async* {
      yield MoviesState.initial();

      var result = await _getMoviesInteractor();

      yield* result.when(success: (movies) async* {
        yield state.copyWith(
          movieResult: movies,
          state: InteractorState.success(),
        );
      }, error: (movies) async* {
        yield state.copyWith(
          movieResult: MovieResult(message: 'Failed Fetch', results: []),
          state: InteractorState.error(),
        );
      }, networkError: (movies) async* {
        yield state.copyWith(
          movieResult: MovieResult(message: 'Network Error', results: []),
          state: InteractorState.networkError(),
        );
      });
    }, refetchMovies: (e) async* {
      yield state.copyWith(
        buttonState: ButtonStates.loading,
        movieResult: MovieResult(),
        state: InteractorState.loading(),
      );

      var result = await _getMoviesInteractor();

      yield* result.when(success: (movies) async* {
        yield state.copyWith(
          movieResult: movies,
          state: InteractorState.success(),
          buttonState: ButtonStates.succeed,
        );
      }, error: (movies) async* {
        yield state.copyWith(
          movieResult: MovieResult(message: 'Failed Fetch', results: []),
          state: InteractorState.error(),
          buttonState: ButtonStates.failed,
        );
      }, networkError: (movies) async* {
        yield state.copyWith(
          movieResult: MovieResult(message: 'Network Error', results: []),
          state: InteractorState.networkError(),
          buttonState: ButtonStates.failed,
        );
      });
    });
  }
}
