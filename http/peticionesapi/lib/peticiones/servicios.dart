import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

class UserServices {
   Future<Map<String, dynamic>> fetchPokemon(String name) async {
    try {
      var url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to fetch Pokémon: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching Pokémon: $e');
      return {};
    }
  }
}
