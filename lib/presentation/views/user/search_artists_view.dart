import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/providers.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de seleccionar artistas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SearchArtistsView extends ConsumerStatefulWidget {
  const SearchArtistsView({super.key});

  @override
  ConsumerState<SearchArtistsView> createState() => _SearchArtistsViewState();
}

class _SearchArtistsViewState extends ConsumerState<SearchArtistsView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;
  
  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Controlador de la barra de búsqueda
  late TextEditingController _textController;

  // Lista de artistas
  List<Artist> artistsList = [];

  // Lista de artistas que ya están como favoritos
  List<int> favs = [];

  // Lista de artistas filtrados
  List<Artist> filteredArtistsList = [];

  // Lista de nombres de artistas que contiene los artistas seleccionados
  List<String> selectedArtistsList = [];

  // Lista de ids de artistas que contiene los artistas seleccionados
  List<int> selectedArtistsIdsList = [];

  // Timer que controla el tiempo de ejecución
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _textController = TextEditingController();
    _textController.addListener(_onArtistNameChanged);
    _getArtists();
  }

  // Función que obtiene los artistas de la api
  void _getArtists() async {
    final results = await Future.wait([
      getRecommendedArtists(),
      getFavoriteArtists(uid: _uid)
    ]);

    favs = results[1] as List<int>;
    artistsList = (results[0] as List<Artist>)
        .where((artist) => !favs.contains(artist.id))
        .toList();

    filteredArtistsList = List.from(artistsList);

    setState(() {});
  }

  // Función que se llama cuando el nombre del artista a buscar ha cambiado
  void _onArtistNameChanged() {
    _debounce?.cancel();
    String artistName = _textController.text;

    // Primero comprobamos que el nombre del artista no esté vacío
    if (artistName.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 700), () {
        _searchArtist(artistName);
      });
    } else {
      setState(() {
        filteredArtistsList = artistsList;
      });
    }
  }

  // Función que busca a los artistas
  Future<void> _searchArtist(String query) async {
    // Primero busca en la lista local de artistas
    List<Artist> localResults = artistsList
        .where(
            (artist) => artist.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (localResults.isNotEmpty) {
      setState(() {
        filteredArtistsList = localResults;
      });
    } else {
      // Si no está en la lista local, busca en Deezer usando searchArtist
      List<Artist> externalResults = await searchArtist(query);
      externalResults = externalResults
          .where((artist) => !favs.contains(artist.id))
          .toList();

      setState(() {
        filteredArtistsList = externalResults;
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
          localization.search_artists_title.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // Barra de búsqueda
          CustomSearch(
            placeholder:
                capitalizeFirstLetter(text: localization.search_artist),
            suffixIcon: Icon(Icons.search),
            textEditingController: _textController,
          ),

          SizedBox(height: 20),

          // Contenedor donde se muestran los artistas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Número de columnas
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: filteredArtistsList.length,
                  itemBuilder: (context, index) {
                    // Cogemos al artista
                    final artist = filteredArtistsList[index];

                    // Pasamos el nombre del artista a minúsculas
                    String artistNameLower = artist.name.toLowerCase();

                    // Comprobamos si está seleccionado
                    final isSelected =
                        selectedArtistsList.contains(artistNameLower);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Si ya está seleccionado lo eliminamos de la lista
                          if (isSelected) {
                            selectedArtistsList.remove(artistNameLower);
                            selectedArtistsIdsList.remove(artist.id);
                          } else {
                            // En caso contrario, los añadimos
                            selectedArtistsList.add(artistNameLower);
                            selectedArtistsIdsList.add(artist.id);
                          }
                        });
                      },
                      child: SelectWidget(
                          photoUrl: artist.picture,
                          artistName: artist.name,
                          isSelected: isSelected),
                    );
                  }),
            ),
          ),

          // Botón para guardar los artistas seleccionados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: CustomButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  // Obtenemos el número de artistas guardados
                  int numArtistsSaved = await addArtistToFavorites(uid: _uid, artists: selectedArtistsIdsList);

                  if (numArtistsSaved > 0) {
                    ref.read(artistsChangedProvider.notifier).state++;
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
