import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "package:cached_network_image/cached_network_image.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Material App",
      home: PokemonInfoScreen(),
    );
  }
}

class PokemonInfoScreen extends StatefulWidget {
  @override
  _PokemonInfoScreenState createState() => _PokemonInfoScreenState();
}

class _PokemonInfoScreenState extends State<PokemonInfoScreen> {
  String _pokemonName = "";
  String _pokemonImageUrl = "";

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon Info"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Enter Pokémon name",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var pokemonName = _controller.text.trim();
                  if (pokemonName.isNotEmpty) {
                    var pokemonData = await fetchPokemon(pokemonName);
                    setState(() {
                      _pokemonName = pokemonData["name"];
                      _pokemonImageUrl = pokemonData["sprites"]["front_default"];
                    });
                  }
                },
                child: const Text("Search"),
              ),
              const SizedBox(height: 20),
              _pokemonName.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _pokemonName,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        _pokemonImageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _pokemonImageUrl,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                width: 150,
                                height: 150,
                              )
                            : Container(),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchPokemon(String name) async {
    try {
      var url = Uri.parse("https://pokeapi.co/api/v2/pokemon/$name");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to fetch Pokémon: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error fetching Pokémon: $e");
      return {};
    }
  }
}