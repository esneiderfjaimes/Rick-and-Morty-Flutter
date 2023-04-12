import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/theme/scaffold_theme_switch.dart';

import '../models/character.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  CharactersQuery? _charactersQuery;

  Future<CharactersQuery> fetchData() async {
    if (_charactersQuery != null) return _charactersQuery!;

    final response =
        await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = json.decode(response.body);
      var query = CharactersQuery.fromJson(jsonMap);
      _charactersQuery = query;
      return query;
    } else {
      throw Exception("Error code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldThemeSwitch(
      title: 'Characters',
      body: FutureBuilder<CharactersQuery>(
        future: fetchData(),
        builder: (_, AsyncSnapshot<CharactersQuery> snapshot) {
          if (_charactersQuery != null) {
            return _buildGrid(_charactersQuery!.results);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var data = snapshot.data!;
            return _buildGrid(data.results);
          } else {
            return Center(child: Text(snapshot.error.toString()));
          }
        },
      ),
    );
  }

  Widget _buildGrid(List<Character> characters) {
    return AlignedGridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return _buildItemCharacter(character);
      },
    );
  }

  Widget _buildItemCharacter(Character character) {
    var colorStatus = character.status == "Alive"
        ? Colors.green
        : character.status == "Dead"
            ? Colors.red
            : Colors.grey;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                character.image,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(letterSpacingFactor: 0.0),
                children: [
                  TextSpan(
                    text: character.status,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colorStatus),
                  ),
                  TextSpan(
                    text: "\n${character.name}",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "\n${character.species}, ${character.gender}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
