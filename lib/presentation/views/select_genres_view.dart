import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/models/genre.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de seleccionar géneros <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SelectGenresView extends StatefulWidget {
  const SelectGenresView({super.key});

  @override
  State<SelectGenresView> createState() => _SelectGenresViewState();
}

class _SelectGenresViewState extends State<SelectGenresView> {
  // Controlador de la barra de búsqueda
  late TextEditingController _textController;

  // Lista de géneros
  List<Genre> genresList = [];

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
    _textController = TextEditingController();
    _textController.addListener(_onGenreNameChanged);
    _getgenres();
  }

  // Función que obtiene los géneros de la api
  void _getgenres() async {
    List<Genre> genres = await getAllGenres();

    // Quitamos el género 'todos' cuya ID es el 0
    genres.removeWhere((g) => g.id == 0);

    setState(() {
      genresList = genres;
      filteredGenresList = genres;
    });
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
        title: Text(capitalizeFirstLetter(text: localization.select_genres)),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // Barra de búsqueda
          CustomSearch(
            placeholder:
                capitalizeFirstLetter(text: localization.search_genre),
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
                  int numGenresSaved = await addGenreToFavorites(genres: selectedGenresIdsList);

                  if (numGenresSaved > 0) {
                    context.go('/home/4');
                  }
                },
                text: localization.done.toUpperCase(),
                disabled: selectedGenresIdsList.length < 3,
            ),
          )
        ],
      ),
    );
  }
}
