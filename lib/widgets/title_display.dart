import 'dart:io';

import 'package:flutter/material.dart';

import 'package:unreel/models/movie.dart';
import 'package:unreel/services/files.dart';
import 'package:unreel/widgets/title_bar.dart';

class TitleDisplay extends StatelessWidget {
  final Movie movie;
  final bool isSaved;
  TitleDisplay({@required this.movie, @required this.isSaved});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ShaderMask(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: isSaved
                ? FutureBuilder<File>(
                    future: Files.getLocalFile(
                        movie.backdropPath.replaceFirst('/', '')),
                    builder: (context, snapshot) =>
                        snapshot != null && snapshot.data != null
                            ? Image.file(
                                snapshot.data,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'images/transparent_backdrop.png',
                                fit: BoxFit.cover,
                              ),
                  )
                : FadeInImage(
                    fit: BoxFit.cover,
                    image: movie != null && movie.backdropPath != null
                        ? NetworkImage('https://image.tmdb.org/t/p/w780' +
                            movie.backdropPath)
                        : AssetImage('images/transparent_backdrop.png'),
                    placeholder: AssetImage('images/transparent_backdrop.png'),
                  ),
          ),
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0xFF131C25)],
              stops: [
                0.5,
                1.0,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleBar(movie: movie),
        ),
      ],
    );
  }
}
