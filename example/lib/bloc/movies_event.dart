part of 'movies_bloc.dart';

@freezed
abstract class MoviesEvent with _$MoviesEvent {
  const factory MoviesEvent.loadMovies() = _LoadMovies;
  const factory MoviesEvent.refetchMovies() = _RefetchMovies;
}
