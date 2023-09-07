import 'package:flutter/material.dart';
import 'package:news_movies/models/models.dart';
import 'package:news_movies/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 180,
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final cast = snapshot.data;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'Actors',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast!.length,
                  itemBuilder: (BuildContext context, int i) => _CastCard(
                    cast: cast[i],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;
  const _CastCard({
    Key? key,
    required this.cast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 290,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(cast.fullProfilePath),
              fit: BoxFit.cover,
              height: 160,
              width: 120,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),
          if (cast.character != '')
            Text(
              'Como: ${cast.character}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
