import 'package:flutter/material.dart';
import 'package:news_movies/models/movie.dart';
import 'package:news_movies/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.delete_forever))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    if (query.isEmpty) {
      return const EmptyData();
    }

    movieProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: movieProvider.suggestionStrem,
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const EmptyData();
        final movies = snapshot.data;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: movies!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListMovies(movie: movies[index]);
          },
        );
      },
    );
  }
}

class ListMovies extends StatelessWidget {
  final Movie movie;
  const ListMovies({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = '${movie.id}-search-screen';
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
      ),
    );
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.sentiment_dissatisfied),
          SizedBox(
            width: 10,
          ),
          Text(
            'No hay resultados',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ],
      ),
    );
  }
}
