import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:news_movies/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        height: size.height / 2,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      color: Colors.black,
      height: size.height / 2,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.7,
        itemHeight: size.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          movies[index].heroId = 'swiped-hero${movies[index].id}';
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: movies[index]),
            child: Hero(
              tag: movies[index].heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage('${movies[index].fullPosterImg}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // ''
}
