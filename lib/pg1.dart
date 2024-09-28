import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokimon/pg3.dart';
import 'model.dart'; // Ensure this imports your PokemonService and PokemonDetailScreen
import 'pg2.dart'; // If pg2.dart is your detail screen

class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final PokemonService pokemonService = PokemonService();
  final ScrollController _scrollController = ScrollController();
  List<String> pokemonNames = [];
  List<String> displayedPokemonNames = [];
  String searchQuery = "";
  bool isLoading = false;
  int offset = 0;

  // Create a list to track likes
  List<bool> likedPokemon = [];

  @override
  void initState() {
    super.initState();
    _loadMorePokemon();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMorePokemon();
      }
    });
  }

  Future<void> _loadMorePokemon() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final newPokemonNames = await pokemonService.fetchPokemonNames(offset: offset, limit: 0);
      setState(() {
        offset += newPokemonNames.length; // Update offset based on fetched names
        pokemonNames.addAll(newPokemonNames);
        likedPokemon.addAll(List<bool>.filled(newPokemonNames.length, false)); // Initialize likes for new Pokémon
        _filterPokemon(searchQuery);
      });
    } catch (e) {
      print('Error fetching Pokémon: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPokemon(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        displayedPokemonNames = pokemonNames; // No search, show all Pokémon
      } else {
        displayedPokemonNames = pokemonNames
            .where((name) =>
        name.toLowerCase().contains(searchQuery) ||
            (pokemonNames.indexOf(name) + 1).toString() == searchQuery) // Search by name or ID
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Pokédex",
                  style: GoogleFonts.nunito(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Search for a Pokémon by name or using its National Pokédex number.",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                )
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 90,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Name or number',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 13.0),
                            child: Icon(Icons.search),
                          ),
                        ),
                        onChanged: _filterPokemon, // Directly pass the updated search query
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey[50],
                    child: IconButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => pg3()),

                      );
                    }, icon: Icon(Icons.favorite, color: Colors.red,)),
                  ),
                )
        
              ],
            ),
            Expanded(
              child: displayedPokemonNames.isEmpty && !isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loader if no data yet
                  : GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: displayedPokemonNames.length + (isLoading ? 1 : 0), // Add one for loading indicator
                itemBuilder: (context, index) {
                  if (index == displayedPokemonNames.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final pokemonName = displayedPokemonNames[index];
                  final pokemonId = pokemonNames.indexOf(pokemonName) + 1;
        
                  return GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PokemonDetailScreen(pokemonId: pokemonId.toString()),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png',
                                fit: BoxFit.fill,
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
                              '00$pokemonId',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  likedPokemon[index] = !likedPokemon[index]; // Toggle like state
                                });
                              },
                              icon: likedPokemon[index]
                                  ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                                  : Icon(
                                Icons.favorite_border_sharp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}