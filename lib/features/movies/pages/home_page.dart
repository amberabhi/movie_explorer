import 'package:flutter/material.dart';
import 'popular_movies_page.dart';
import 'search_movies_page.dart';
import 'favourites_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Explorer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // same size
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PopularMoviesPage()),
                );
              },
              child: const Text('Popular Movies'),
            ),
            const SizedBox(height: 20), // spacing
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // same size
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchMoviesPage()),
                );
              },
              child: const Text('Search Movies'),
            ),
            const SizedBox(height: 20), // spacing
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // match others
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                );
              },
              child: const Text('Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
