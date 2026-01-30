import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_explorer/features/movies/models/movie_model.dart';

class ApiService {
  static final String baseUrl = 'https://api.themoviedb.org/3';
  static final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  // Fetch popular movies (paginated)
  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final url = Uri.parse(
      '$baseUrl/movie/popular'
      '?api_key=$apiKey'
      '&language=en-US'
      '&page=$page',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List moviesJson = data['results'];

      return moviesJson
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Search movies by query (paginated)
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final url = Uri.parse(
      '$baseUrl/search/movie'
      '?api_key=$apiKey'
      '&query=$query'
      '&language=en-US'
      '&page=$page',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  // Fetch movie details by movie ID
  Future<Movie> fetchMovieDetails(int movieId) async {
  final url = Uri.parse(
    '$baseUrl/movie/$movieId'
    '?api_key=$apiKey'
    '&language=en-US',
  );

  final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
