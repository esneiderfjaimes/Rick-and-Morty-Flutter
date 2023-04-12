import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/character.dart';
import '../theme/scaffold_theme_switch.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final PagingController<int, Character> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await http.get(
          Uri.parse('https://rickandmortyapi.com/api/character?page=$pageKey'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        var query = CharactersQuery.fromJson(jsonMap);
        final isLastPage = query.info.next == null;
        if (isLastPage) {
          _pagingController.appendLastPage(query.results);
        } else {
          String url = query.info.next!;
          Uri uri = Uri.parse(url);
          String page = uri.queryParameters['page']!;
          int nextPageKey = int.parse(page);
          _pagingController.appendPage(query.results, nextPageKey);
        }
      } else {
        throw Exception("Error code: ${response.statusCode}");
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldThemeSwitch(
      title: 'Characters',
      body: PagedGridView<int, Character>(
        padding: const EdgeInsets.all(20),
        pagingController: _pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        builderDelegate: PagedChildBuilderDelegate<Character>(
          itemBuilder: (context, item, index) => _buildItemCharacter(
            item,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Widget _buildItemCharacter(Character character) {
    var colorStatus = character.status == "Alive"
        ? Colors.green
        : character.status == "Dead"
            ? Colors.red
            : Colors.grey;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/character',
          arguments: character,
        );
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: character.id.toString(),
                child: ClipOval(
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                  ),
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
    );
  }
}
