import 'package:flutter/material.dart';
import 'package:movie_explorer/features/movies/services/api_services.dart';
import 'package:movie_explorer/features/movies/models/movie_model.dart';
import 'package:movie_explorer/features/movies/pages/movie_details_page.dart';
import '../services/favourites_services.dart'; 

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  final ApiService apiService = ApiService();

  List<Movie> movies = [];
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() => isLoading = true);

    try {
      final fetchedMovies =
          await apiService.fetchPopularMovies(page: currentPage);

      setState(() {
        movies = fetchedMovies; // replace per page
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch movies')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void nextPage() {
    currentPage++;
    fetchMovies();
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies (Page $currentPage)'),
      ),
      body: Column(
        children: [
          // 🔹 Movie List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : movies.isEmpty
                    ? const Center(child: Text('No movies found'))
                    : ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];

                          return ListTile(
                            title: Text(
                              movie.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              movie.overview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: FutureBuilder<bool>(
                              future: FavoritesService.isFavorite(movie.id),
                              builder: (context, snapshot) {
                                final isFav = snapshot.data ?? false;
                                return IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    if (isFav) {
                                      await FavoritesService.removeFavorite(
                                          movie.id);
                                    } else {
                                      await FavoritesService.addFavorite(
                                          movie.id);
                                    }
                                    setState(() {}); // Refresh UI
                                  },
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailsPage(
                                    movieId: movie.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),

          // Pagination Buttons
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1 ? previousPage : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: movies.isNotEmpty ? nextPage : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
