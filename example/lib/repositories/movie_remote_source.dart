import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:example/constants/url.dart';
import 'package:example/entities/movie_item_entity.dart';
import 'package:example/resource/resource_state.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class MovieRemoteSource {
  Future<ResourceState<MovieResult>> getMovies() async {
    MovieRepository repository = MovieRepository();
    ApiUrl apiUrl = ApiUrl();
    try {
      var response = await http.get(apiUrl.nowPlayingUrl);
      if (response.statusCode == 200) {
        repository.movieResult = MovieResult.fromJson(
          jsonDecode(response.body),
        );
        return ResourceState.success(
            MovieResult.fromJson(json.decode(response.body)));
      } else {
        return ResourceState.error(
            MovieResult.fromJson(json.decode(response.body)));
      }
    } on TimeoutException {
      return ResourceState.networkError(
        MovieResult(message: 'Timeout Exception'),
      );
    } on SocketException {
      return ResourceState.networkError(
        MovieResult(message: 'No Network'),
      );
    } on HttpException {
      return ResourceState.networkError(
        MovieResult(message: 'Doesn\'t Get All Datas'),
      );
    }
  }
}

class MovieRepository {
  MovieResult movieResult;
}
