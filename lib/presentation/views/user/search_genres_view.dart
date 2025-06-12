import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/providers.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/genre.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de seleccionar géneros <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SearchGenresView extends ConsumerStatefulWidget {
  const SearchGenresView({super.key});

  @override
  ConsumerState<SearchGenresView> createState() => _SearchGenresViewState();
}

class _SearchGenresViewState extends ConsumerState<SearchGenresView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Controlador de la barra de búsqueda
  late TextEditingController _textController;

  // Lista de géneros
  List<Genre> genresList = [];

  // Lista de géneros que ya están como favoritos
  List<int> favs = [];

  // Lista de géneros filtrados
  List<Genre> filteredGenresList = [];

  // Lista de nombres de géneros que contiene los géneros seleccionados
  List<String> selectedGenresList = [];

  // Lista de ids de géneros que contiene los géneros seleccionados
  List<int> selectedGenresIdsList = [];

  // Timer que controla el tiempo de ejecución
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _textController = TextEditingController();
    _textController.addListener(_onGenreNameChanged);
    _getGenres();
  }

  // Función que obtiene los géneros de la api
  void _getGenres() async {
    final results =
        await Future.wait([getAllGenres(), getFavoriteGenres(uid: _uid)]);

    favs = results[1] as List<int>;
    genresList = (results[0] as List<Genre>)
        .where((artist) => !favs.contains(artist.id))
        .toList();

    // Quitamos el género 'todos' cuya ID es el 0
    genresList.removeWhere((g) => g.id == 0);

    filteredGenresList = List.from(genresList);

    setState(() {});
  }

  // Función que se llama cuando el nombre del género a buscar ha cambiado
  void _onGenreNameChanged() {
    _debounce?.cancel();
    String genreName = _textController.text;

    // Primero comprobamos que el nombre del género no esté vacío
    if (genreName.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 700), () {
        _searchGenre(genreName);
      });
    } else {
      setState(() {
        filteredGenresList = genresList;
      });
    }
  }

  // Función que busca a los géneros
  Future<void> _searchGenre(String query) async {
    // Primero busca en la lista local de géneros
    List<Genre> localResults = genresList
        .where(
            (genre) => genre.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (localResults.isNotEmpty) {
      setState(() {
        filteredGenresList = localResults;
      });
    } else {
      // Si no está en la lista local, busca en Deezer usando searchgenre
      List<Genre> externalResults = await searchGenre(query);
      externalResults =
          externalResults.where((artist) => !favs.contains(artist.id)).toList();

      setState(() {
        filteredGenresList = externalResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(
          localization.search_genres_title.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // Barra de búsqueda
          CustomSearch(
            placeholder: capitalizeFirstLetter(text: localization.search_genre),
            suffixIcon: Icon(Icons.search),
            textEditingController: _textController,
          ),

          SizedBox(height: 20),

          // Contenedor donde se muestran los géneros
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Número de columnas
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: filteredGenresList.length,
                  itemBuilder: (context, index) {
                    // Cogemos al genrea
                    final genre = filteredGenresList[index];

                    // Pasamos el nombre del genrea a minúsculas
                    String genreNameLower = genre.name.toLowerCase();

                    // Comprobamos si está seleccionado
                    final isSelected =
                        selectedGenresList.contains(genreNameLower);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Si ya está seleccionado lo eliminamos de la lista
                          if (isSelected) {
                            selectedGenresList.remove(genreNameLower);
                            selectedGenresIdsList.remove(genre.id);
                          } else {
                            // En caso contrario, los añadimos
                            selectedGenresList.add(genreNameLower);
                            selectedGenresIdsList.add(genre.id);
                          }
                        });
                      },
                      child: SelectWidget(
                          photoUrl: genre.picture,
                          artistName: genre.name,
                          isSelected: isSelected),
                    );
                  }),
            ),
          ),

          // Botón para guardar los géneros seleccionados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: CustomButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                // Obtenemos el número de géneros guardados
                int numGenresSaved = await addGenreToFavorites(
                    uid: _uid, genres: selectedGenresIdsList);

                if (numGenresSaved > 0) {
                  ref.read(genresChangedProvider.notifier).state++;
                  Navigator.pop(context);
                }
              },
              text: localization.add.toUpperCase(),
            ),
          )
        ],
      ),
    );
  }
}
