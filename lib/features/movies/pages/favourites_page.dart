import 'package:flutter/material.dart';
import '../services/favourites_services.dart';
import '../services/api_services.dart';
import '../models/movie_model.dart';
import 'movie_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ApiService apiService = ApiService();
  List<Movie> favoriteMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    setState(() => isLoading = true);

    try {
      final favIds = await FavoritesService.getFavorites();
      final List<Movie> movies = [];

      // Fetch movie details for each favorite ID
      for (int id in favIds) {
        movies.add(await apiService.fetchMovieDetails(id));
      }

      setState(() {
        favoriteMovies = movies;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load favorites')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteMovies.isEmpty
              ? const Center(child: Text('No favorites yet'))
              : ListView.builder(
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];
                    return ListTile(
                      title: Text(movie.title),
                      subtitle: Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MovieDetailsPage(movieId: movie.id),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
