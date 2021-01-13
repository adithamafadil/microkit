import 'package:example/entities/movie_item_entity.dart';
import 'package:example/repositories/movie_remote_source.dart';
import 'package:example/resource/resource_state.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetMoviesInteractor {
  MovieRemoteSource movieRemoteSource = MovieRemoteSource();
  Future<ResourceState<MovieResult>> call() async {
    return movieRemoteSource.getMovies();
  }
}
