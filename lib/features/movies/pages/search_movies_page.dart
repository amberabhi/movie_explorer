import 'package:flutter/material.dart';
import 'package:movie_explorer/features/movies/services/api_services.dart';
import 'package:movie_explorer/features/movies/models/movie_model.dart';

class SearchMoviesPage extends StatefulWidget {
  const SearchMoviesPage({super.key});

  @override
  State<SearchMoviesPage> createState() => _SearchMoviesPageState();
}

class _SearchMoviesPageState extends State<SearchMoviesPage> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();

  List<Movie> movies = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> searchMovies() async {
    final query = searchController.text.trim();

    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final results = await apiService.searchMovies(query: query);
      setState(() {
        movies = results;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to search movies';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => searchMovies(),
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: searchMovies,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : movies.isEmpty
                          ? const Center(
                              child: Text('No results'),
                            )
                          : ListView.builder(
                              itemCount: movies.length,
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return ListTile(
                                  title: Text(movie.title),
                                  subtitle: Text(
                                    movie.overview,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
