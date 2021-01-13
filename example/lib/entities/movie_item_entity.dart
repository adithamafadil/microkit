import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_item_entity.g.dart';
part 'movie_item_entity.freezed.dart';

//flutter pub run build_runner build
@freezed
abstract class MovieItemEntity with _$MovieItemEntity {
  const factory MovieItemEntity({
    @JsonKey(name: 'poster_path') String posterPath,
    @JsonKey(name: 'backdrop_path') String backdropPath,
    @JsonKey(name: 'original_title') String originalTitle,
    @JsonKey(name: 'release_date') String releaseDate,
    String title,
    String overview,
  }) = _MovieItemEntity;

  factory MovieItemEntity.fromJson(Map<String, dynamic> json) =>
      _$MovieItemEntityFromJson(json);
}

@freezed
abstract class MovieResult with _$MovieResult {
  const factory MovieResult({
    String message,
    List<MovieItemEntity> results,
  }) = _MovieResult;

  factory MovieResult.fromJson(Map<String, dynamic> json) =>
      _$MovieResultFromJson(json);
}
