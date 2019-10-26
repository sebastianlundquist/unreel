import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_data.dart';
import 'package:movie_app/widgets/title_bar.dart';
import 'package:provider/provider.dart';

class TitleDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ShaderMask(
          child: Consumer<MovieData>(
            builder: (context, movieData, child) {
              return FadeInImage(
                placeholder: AssetImage('images/transparent_backdrop.png'),
                image: movieData.backdropImage,
              );
            },
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
          child: TitleBar(),
        ),
      ],
    );
  }
}
