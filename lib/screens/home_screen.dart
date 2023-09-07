import 'package:flutter/material.dart';
import 'package:news_movies/search/search_delegate.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movies on Cines'),
          actions: [
            IconButton(
                onPressed: () => showSearch(
                    context: context, delegate: MovieSearchDelegate()),
                icon: const Icon(Icons.search))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(
                movies: moviesProvider.onDisplayMovies,
              ),

              // Listado de peliculas horizontal
              MovieSlider(
                movies: moviesProvider.onPopularMovies,
                title: 'Populares',
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
              const SizedBox(
                height: 20,
              ),
              MovieSlider(
                movies: moviesProvider.onRaitingResponse,
                title: 'Mejores Votadas',
                onNextPage: () => moviesProvider.getRaitingMovies(),
              ),
              const SizedBox(
                height: 20,
              ),
              MovieSlider(
                movies: moviesProvider.onUpcomingResponse,
                title: 'Proximamente',
                onNextPage: () => moviesProvider.getUpcomingMovies(),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}
