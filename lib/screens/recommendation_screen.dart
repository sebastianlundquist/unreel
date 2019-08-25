import 'package:flutter/material.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/components/star_display.dart';

const imageURL = 'https://image.tmdb.org/t/p';
const posterSmallSize = '/w154';
const posterLargeSize = '/w500';
const backdropSize = '/w780';

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  int minReleaseDate = 2000;
  int maxReleaseDate = 2010;
  int minVoteCount = 100;
  double minVoteAverage = 7.0;
  dynamic movieData;
  Movie movieObject;
  int movieIndex = 0;
  int page = 1;

  String title;
  String description;

  dynamic img = AssetImage('images/transparent.png');
  dynamic backdropImage = AssetImage('images/transparent.png');

  void updateUI(dynamic movieData, int index) {
    setState(() {
      movieObject = Movie.fromJson(movieData['results'][index]);
      print(movieObject.title);
      movieIndex++;
      img = NetworkImage('$imageURL$posterSmallSize${movieObject.posterPath}');
      backdropImage =
          NetworkImage('$imageURL$backdropSize${movieObject.backdropPath}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ShaderMask(
                child: FadeInImage(
                  placeholder: AssetImage('images/transparent.png'),
                  image: backdropImage,
                ),
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xFF000000)],
                    stops: [
                      0.5,
                      1.0,
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            movieObject != null ? movieObject.title : '',
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                IconTheme(
                                  data: IconThemeData(
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  child: StarDisplay(
                                      value: movieObject.voteAverage),
                                ),
                                Text(
                                  movieObject != null
                                      ? movieObject.voteCount.toString() +
                                          ' votes'
                                      : '',
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              movieObject != null
                                  ? movieObject.voteAverage.toString()
                                  : '',
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              movieObject != null ? movieObject.overview : '',
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Original Title:'),
                    ),
                    Expanded(
                      child: Text(
                          movieObject != null ? movieObject.originalTitle : ''),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Genres:'),
                    ),
                    Expanded(
                      child: Text(''),
                      flex: 2,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Release Date:'),
                    ),
                    Expanded(
                      child: Text(movieObject != null
                          ? movieObject.releaseDate.toString()
                          : ''),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Original Language:'),
                    ),
                    Expanded(
                      child: Text(movieObject != null
                          ? movieObject.originalLanguage
                          : ''),
                      flex: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Text('Get Movies'),
                onPressed: () async {
                  if (movieIndex == 20) {
                    movieIndex = 0;
                    page++;
                  }
                  if (movieIndex == 0) {
                    movieData = await Movies().getMovies(minReleaseDate,
                        maxReleaseDate, minVoteCount, minVoteAverage, page);
                  }
                  updateUI(movieData, movieIndex);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
Padding(
padding: const EdgeInsets.all(16.0),
child: Center(
child: Column(
children: <Widget>[
Expanded(
child: Column(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
crossAxisAlignment: CrossAxisAlignment.center,
children: <Widget>[
Text(
movieObject != null ? movieObject.overview : '',
style: Theme.of(context).textTheme.body1,
),
],
),
),
Expanded(
child: RaisedButton(
child: Text('Get Movies'),
onPressed: () async {
if (movieIndex == 20) {
movieIndex = 0;
page++;
}
if (movieIndex == 0) {
movieData = await Movies().getMovies(
minReleaseDate,
maxReleaseDate,
minVoteCount,
minVoteAverage,
page);
}
updateUI(movieData, movieIndex);
},
),
),
],
),
),
),
*/
