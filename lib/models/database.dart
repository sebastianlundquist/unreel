import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'movie.dart';

class MovieDatabase {
  MovieDatabase._();
  static final MovieDatabase db = MovieDatabase._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MovieDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Movie ("
          "adult BIT,"
          "backdrop_path TEXT,"
          "belongs_to_collection TEXT,"
          "budget INTEGER,"
          "genres TEXT,"
          "homepage TEXT,"
          "id INTEGER PRIMARY KEY,"
          "imdb_id TEXT,"
          "original_language TEXT,"
          "original_title TEXT,"
          "overview TEXT,"
          "popularity DOUBLE,"
          "poster_path TEXT,"
          "production_companies TEXT,"
          "production_countries TEXT,"
          "release_date TEXT,"
          "revenue INTEGER,"
          "runtime INTEGER,"
          "spoken_languages TEXT,"
          "status TEXT,"
          "tagline TEXT,"
          "title TEXT,"
          "video BIT,"
          "vote_average DOUBLE,"
          "vote_count INTEGER"
          ")");
    });
  }

  newMovie(Movie newMovie) async {
    final db = await database;
    print(json.encode(newMovie.genres.first));
    var res = await db.insert("Movie", newMovie.toJson());
    print(newMovie.genres.toString());
    return res;
  }

  Future<Movie> getMovie(int id) async {
    final db = await database;
    var res = await db.query("Movie", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Movie.fromSqLite(res.first) : null;
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    var res = await db.query("Movie");
    List<Movie> list = res.isNotEmpty
        ? res.map((m) => Movie.fromSqLite(m)).toList()
        : List<Movie>();
    return list;
  }

  getMoviesWithCondition(String query) async {
    final db = await database;
    var res = await db.rawQuery(query);
    List<Movie> list =
        res.isNotEmpty ? res.map((c) => Movie.fromSqLite(c)).toList() : [];
    return list;
  }

  deleteMovie(int id) async {
    final db = await database;
    db.delete("Movie", where: "id = ?", whereArgs: [id]);
  }
}
