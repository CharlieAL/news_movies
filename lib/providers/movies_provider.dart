// import 'dart:convert';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_movies/helpers/debouncer.dart';
import 'package:news_movies/models/models.dart';

class MovieProvider extends ChangeNotifier {
  final String _url = 'api.themoviedb.org';
  final String _lenguege = 'es-Es';
  final String _apiKey = '92f94a5ed4b64b65bdaf6ec90d41aa24';
  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];
  List<Movie> onRaitingResponse = [];
  List<Movie> onUpcomingResponse = [];

  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStrem =>
      _suggestionsStreamController.stream;

  int _popularPage = 0;
  MovieProvider() {
    getOnNowMovies();
    getPopularMovies();
    getRaitingMovies();
    getUpcomingMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_url, endpoint,
        {'api_key': _apiKey, 'language': _lenguege, 'page': '$page'});
    final response = await http.get(url);
    return response.body;
  }

  getOnNowMovies() async {
    final data = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(data);
    // print('ya');
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final data = await _getJsonData('3/movie/popular', _popularPage);
    final popularMoviesResponse = PopularResponse.fromJson(data);
    onPopularMovies = [...onPopularMovies, ...popularMoviesResponse.results];
    notifyListeners();
  }

  getRaitingMovies() async {
    final data = await _getJsonData('3/movie/top_rated');
    final raitingResponse = Rating.fromJson(data);
    // print('ya');
    onRaitingResponse = raitingResponse.results;
    notifyListeners();
  }

  getUpcomingMovies() async {
    final data = await _getJsonData('3/movie/upcoming');
    final upcomingResponse = NowPlayingResponse.fromJson(data);
    // print('ya');
    onUpcomingResponse = upcomingResponse.results;
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    // revisar el mapa si esta el id devolver los datos si no hacer la peticion http
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final data = await _getJsonData('3/movie/$movieId/credits');
    final response = CreditResponse.fromJson(data);
    moviesCast[movieId] = response.cast;
    print('pidiendo datos al servidor');

    return response.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(
      _url,
      '3/search/movie',
      {
        'query': query,
        'api_key': _apiKey,
        'language': _lenguege,
        'page': '1',
        'include_adult': 'true'
      },
    );
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final result = await searchMovie(value);
      _suggestionsStreamController.add(result);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
