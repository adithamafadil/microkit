import 'package:injectable/injectable.dart';

@Environment('dev')
@lazySingleton
class ApiUrl {
  String nowPlayingUrl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=befc21d948862259da6f029c54831a9c&language=en-US&page=1&region=ID';
}
