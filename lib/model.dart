import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonService {
  Future<List<String>> fetchPokemonNames({required int limit, required int offset}) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=0&limit=20'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      List<String> pokemonNames = [];
      for (var pokemon in data['results']) {
        pokemonNames.add(pokemon['name']);
      }
      return pokemonNames;
    } else {
      throw Exception('Failed to load Pokémon names');
    }
  }

  fetchPokemon(int offset, int limit) {}
}