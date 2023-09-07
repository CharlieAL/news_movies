// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:news_movies/models/movie.dart';
import 'package:news_movies/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(title: movie.title, imageUrl: movie.fullbackdropImg),
        SliverList(
          delegate: SliverChildListDelegate([
            _PosterAndTitle(
              movieId: movie.heroId!,
              imageUrl: movie.fullPosterImg,
              title: movie.title,
              titleOriginal: movie.originalTitle,
              voteAvg: movie.voteAverage,
            ),
            _MovieDescription(
              overview: movie.overview,
            ),
            CastingCards(
              movieId: movie.id,
            ),
            SizedBox(
              height: 20,
            )
          ]),
        )
      ],
    ));
  }
}

class _MovieDescription extends StatelessWidget {
  final String overview;
  const _MovieDescription({
    Key? key,
    required this.overview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Text(
        overview,
        style: textTheme.subtitle1,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String titleOriginal;
  final double voteAvg;
  final String movieId;
  const _PosterAndTitle({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.titleOriginal,
    required this.voteAvg,
    required this.movieId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movieId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(imageUrl),
                height: 150,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headline5,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  titleOriginal,
                  style: textTheme.subtitle1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 12,
                    ),
                    Text(
                      '$voteAvg',
                      style: textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String title;
  final String imageUrl;
  const _CustomAppBar({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(0),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(imageUrl),
          fit: BoxFit.fitHeight,
        ),
        collapseMode: CollapseMode.pin,
      ),
    );
  }
}
