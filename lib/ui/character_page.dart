import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/character.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key, String? characterId}) : super(key: key);

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

const imageSize = 150.0;

class _CharacterPageState extends State<CharacterPage> {
  ScrollController _scrollController = ScrollController();
  bool _isScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isScroll = _scrollController.offset != 0;
    });
  }

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
        title: Text(_isScroll ? character.name : ''),
        backgroundColor: _isScroll
            ? Theme.of(context).colorScheme.surface
            : Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: imageSize,
                  height: imageSize,
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
            ),
            Positioned.fill(
              top: imageSize / 2,
              child: SafeArea(
                child: Container(color: Theme.of(context).colorScheme.surface),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Hero(
                    tag: character.id.toString(),
                    child: ClipOval(
                      child: Image.network(
                        character.image,
                        fit: BoxFit.cover,
                        width: imageSize,
                        height: imageSize,
                      ),
                    ),
                  ),
                  Text(
                    character.name,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    character.status,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colorStatus),
                  ),
                  _characterInfo(character),
                  Container(
                    height: 1,
                    color: const Color(0x1F808080),
                  ),
                  ..._episodes(character.episode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _episodes(List<String> episodes) {
    List<Widget> widgets = [];
    for (var i = 0; i < episodes.length; i++) {
      List<String> parts = episodes[i].split('/');
      String lastDigit = parts.last;
      widgets.add(Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 40,
          right: 40,
        ),
        color: i % 2 == 0 ? Colors.transparent : const Color(0x0C808080),
        child: Text("EPISODES $lastDigit"),
      ));
    }

    return widgets;
  }

  _characterInfo(Character character) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Table(
        children: [
          TableRow(
            children: [
              _cellAttr('Gender', character.gender),
              _cellAttr('Species', character.species),
            ],
          ),
          TableRow(
            children: [
              _cellAttr('Origin location', character.origin.name),
              _cellAttr('Last known location', character.location.name),
            ],
          ),
        ],
      ),
    );
  }

  _cellAttr(String attrName, String value) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: attrName,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              const TextSpan(text: '\n'),
              TextSpan(
                text: value,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
