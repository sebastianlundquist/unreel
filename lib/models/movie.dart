import 'dart:convert';

class Movie {
  final bool adult;
  final String backdropPath;
  final Object belongsToCollection;
  final int budget;
  final List<dynamic> genres;
  final String homepage;
  final int id;
  final String imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<dynamic> productionCompanies;
  final List<dynamic> productionCountries;
  final String releaseDate;
  final int revenue;
  final int runtime;
  final List<dynamic> spokenLanguages;
  final String status;
  final String tagline;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie(
      this.adult,
      this.backdropPath,
      this.belongsToCollection,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.productionCompanies,
      this.productionCountries,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.spokenLanguages,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount);

  Movie.fromJson(Map<String, dynamic> json)
      : adult = json['adult'],
        backdropPath = json['backdrop_path'],
        belongsToCollection = json['belongs_to_collection'],
        budget = json['budget'],
        genres = json['genres'],
        homepage = json['homepage'],
        id = json['id'],
        imdbId = json['imdb_id'],
        originalLanguage = json['original_language'],
        originalTitle = json['original_title'],
        overview = json['overview'],
        popularity = json['popularity'].toDouble(),
        posterPath = json['poster_path'],
        productionCompanies = json['production_companies'],
        productionCountries = json['production_countries'],
        releaseDate = json['release_date'],
        revenue = json['revenue'],
        runtime = json['runtime'],
        spokenLanguages = json['spoken_languages'],
        status = json['status'],
        tagline = json['tagline'],
        title = json['title'],
        video = json['video'],
        voteAverage = json['vote_average'].toDouble(),
        voteCount = json['vote_count'];

  Movie.fromSqLite(Map<String, dynamic> json)
      : adult = json['adult'] == 0 ? false : true,
        backdropPath = json['backdrop_path'],
        belongsToCollection = json['belongs_to_collection'],
        budget = json['budget'],
        genres = jsonDecode(json['genres']),
        homepage = json['homepage'],
        id = json['id'],
        imdbId = json['imdb_id'],
        originalLanguage = json['original_language'],
        originalTitle = json['original_title'],
        overview = json['overview'],
        popularity = json['popularity'].toDouble(),
        posterPath = json['poster_path'],
        productionCompanies = jsonDecode(json['production_companies']),
        productionCountries = jsonDecode(json['production_countries']),
        releaseDate = json['release_date'],
        revenue = json['revenue'],
        runtime = json['runtime'],
        spokenLanguages = jsonDecode(json['spoken_languages']),
        status = json['status'],
        tagline = json['tagline'],
        title = json['title'],
        video = json['video'] == 0 ? false : true,
        voteAverage = json['vote_average'].toDouble(),
        voteCount = json['vote_count'];

  Map<String, dynamic> toJson() => {
        'adult': adult ? 1 : 0,
        'backdrop_path': backdropPath,
        'belongs_to_collection': belongsToCollection,
        'budget': budget,
        'genres': jsonEncode(genres),
        'homepage': homepage,
        'id': id,
        'imdb_id': imdbId,
        'original_language': originalLanguage,
        'original_title': originalTitle,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'production_companies': jsonEncode(productionCompanies),
        'production_countries': jsonEncode(productionCountries),
        'release_date': releaseDate,
        'revenue': revenue,
        'runtime': runtime,
        'spoken_languages': jsonEncode(spokenLanguages),
        'status': status,
        'tagline': tagline,
        'title': title,
        'video': video ? 1 : 0,
        'vote_average': voteAverage,
        'vote_count': voteCount
      };
}
