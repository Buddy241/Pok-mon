
import 'package:flutter/material.dart';
import 'package:pokimon/pg2.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pg3 extends StatefulWidget {
  @override
  _pg3State createState() => _pg3State();
}

class _pg3State extends State<pg3> {
  List<String> favoritePokemonIds = [];
  Map<String, String> pokemonNames = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favoritePokemon') ?? [];
    setState(() {
      favoritePokemonIds = favorites;
    });
    await _fetchPokemonNames();
  }

  Future<void> _fetchPokemonNames() async {
    Dio dio = Dio();
    try {
      for (String id in favoritePokemonIds) {
        final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$id');
        final String name = response.data['name'];
        setState(() {
          pokemonNames[id] = name;
        });
      }
    } catch (e) {
      print('Error fetching Pokémon names: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        title: Text('Favorite Pokémon'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoritePokemonIds.isEmpty
          ? Center(child: Text('No favorite Pokémon yet.'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.8,
        ),
        itemCount: favoritePokemonIds.length,
        itemBuilder: (context, index) {
          final pokemonId = favoritePokemonIds[index];
          final pokemonName = pokemonNames[pokemonId] ?? 'Loading...';
          return GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailScreen(pokemonId: pokemonId.toString()),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      pokemonName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '$pokemonId',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
