import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key, String? characterId}) : super(key: key);

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    final Character character =
        ModalRoute.of(context)!.settings.arguments as Character;
    var colorStatus = character.status == "Alive"
        ? Colors.green
        : character.status == "Dead"
            ? Colors.red
            : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(character.image),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 100),
            color: Theme.of(context).colorScheme.surface
            ),
        Center(
          child: Column(
            children: [
              Hero(
                tag: character.id.toString(),
                child: ClipOval(
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              Text(
                character.status,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colorStatus),
              ),
              Text(character.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text(
                "${character.species}, ${character.gender}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
