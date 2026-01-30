import 'package:flutter/material.dart';
import 'package:movie_explorer/features/movies/models/movie_model.dart';
import 'package:movie_explorer/features/movies/services/api_services.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final ApiService apiService = ApiService();
  Movie? movie;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    try {
      final result = await apiService.fetchMovieDetails(widget.movieId);
      setState(() {
        movie = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load movie details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (movie == null) {
      return const Scaffold(
        body: Center(child: Text('No data found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(movie!.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie!.posterPath != null)
              Center(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie!.posterPath}',
                ),
              ),
            const SizedBox(height: 16),
            Text(
              movie!.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('⭐ Rating: ${movie!.rating ?? 'N/A'}'),
            Text('📅 Release: ${movie!.releaseDate ?? 'N/A'}'),
            const SizedBox(height: 16),
            const Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(movie!.overview),
          ],
        ),
      ),
    );
  }
}
