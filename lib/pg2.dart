import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonDetailScreen extends StatefulWidget {
  final String pokemonId;

  const PokemonDetailScreen({Key? key, required this.pokemonId}) : super(key: key);

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  String pokemonName = "";
  String pokemonNumber = "";
  String pokemonImageUrl = "";
  List<String> pokemonTypes = [];
  String description = "Loading..."; // Placeholder for description

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails();
  }

  Future<void> fetchPokemonDetails() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${widget.pokemonId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      setState(() {
        pokemonName = data['name'];
        pokemonNumber = data['id'].toString();
        pokemonImageUrl = data['sprites']['front_default'];
        pokemonTypes = List<String>.from((data['types'] as List).map((type) => type['type']['name']));

        description = "In order to support its flower, which has grown larger due to Mega Evolution, its back and legs have become stronger."; // Sample description, modify as needed
      });
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          backgroundColor: Colors.green[50],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                pokemonName.isEmpty ? "Loading..." : pokemonName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                pokemonNumber.isEmpty ? "" : '$pokemonNumber',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: Container(
                    height: 380,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(pokemonImageUrl.isEmpty ? "https://via.placeholder.com/300" : pokemonImageUrl),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: Colors.blue,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "Forms"),
                          Tab(text: "Detail"),
                          Tab(text: "Types"),
                          Tab(text: "Stats"),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: TabBarView(
                          children: [
                            // Forms Tab
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Image.network(pokemonImageUrl, height: 80),
                                ],
                              ),
                            ),
                            // Detail Tab
                            Center(child: Text("Detail ")),
                            // Types Tab
                            Center(child: Text("Types: ${pokemonTypes.join(', ')}")),
                            // Stats Tab
                            Center(child: Text("Stats information here")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Mega Evolution or Description
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Mega Evolution",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}