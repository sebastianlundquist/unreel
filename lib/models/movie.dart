class Movie {
  final int voteCount;
  final int id;
  final bool video;
  final double voteAverage;
  final String title;
  final double popularity;
  final String posterPath;
  final String originalLanguage;
  final String originalTitle;
  final List<dynamic> genreIds;
  final String backdropPath;
  final bool adult;
  final String overview;
  final String releaseDate;

  Movie(
      this.voteCount,
      this.id,
      this.video,
      this.voteAverage,
      this.title,
      this.popularity,
      this.posterPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreIds,
      this.backdropPath,
      this.adult,
      this.overview,
      this.releaseDate);

  Movie.fromJson(Map<String, dynamic> json)
      : voteCount = json['vote_count'],
        id = json['id'],
        video = json['video'],
        voteAverage = json['vote_average'].toDouble(),
        title = json['title'],
        popularity = json['popularity'].toDouble(),
        posterPath = json['poster_path'],
        originalLanguage = json['original_language'],
        originalTitle = json['original_title'],
        genreIds = json['genre_ids'],
        backdropPath = json['backdrop_path'],
        adult = json['adult'],
        overview = json['overview'],
        releaseDate = json['release_date'];

  Map<String, dynamic> toJson() => {
        'vote_count': voteCount,
        'id': id,
        'video': video,
        'vote_average': voteAverage,
        'title': title,
        'popularity': popularity,
        'poster_path': posterPath,
        'original_language': originalLanguage,
        'original_title': originalTitle,
        'genre_ids': genreIds,
        'backdrop_path': backdropPath,
        'adult': adult,
        'overview': overview,
        'release_date': releaseDate,
      };
}
